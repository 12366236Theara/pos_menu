import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:pos_menu/API/domainame.dart';
import 'package:pos_menu/Extension/extension.dart';
import 'package:pos_menu/Infrastructor/ModernPopupDialog.dart';
import 'package:pos_menu/Infrastructor/StyleColor.dart';
import 'package:pos_menu/Infrastructor/modernAnimateLoading.dart';
import 'package:pos_menu/model/menu/menu_detail_model.dart';
import 'package:pos_menu/model/menu/menu_model.dart';
import 'package:pos_menu/model/menu/menu_option_model.dart';

import '../Infrastructor/Singleton.dart';

class MenuProvider extends ChangeNotifier {
  MenuProvider({BuildContext? context}) {
    log("Menu Provider initialized");
  }

  List<MenuModel> menuItems = [];
  // List<MenuDetailModel> _menuDetailItems = [];
  // List<MenuDetailModel> get menuDetailItems => _menuDetailItems;

  MenuDetailModel? menuDetailItems;
  Map<String, List<MenuModel>> groupedMenuByCategory = {};
  List<MenuModel> filteredMenu = [];

  List<String> category = [];
  List<MenuModel> selectedItems = [];
  Map<String, int> cartItems = {}; // Cart: item ID -> quantity
  int? selectedIndex;
  MenuDetailModel? _copiedProduct;

  Color color = StyleColor.mainColor;
  Color get _color => color;

  bool _isColorLoading = false;
  bool get isColorLoading => _isColorLoading;

  MenuDetailModel? get copiedProduct => _copiedProduct;
  // var dio = Singleton.instance.dio;
  final dio = Dio();
  String get _dbCode => Singleton.instance.getDbCode() ?? '';

  Options dioOptions = Options(receiveDataWhenStatusError: true, followRedirects: false, validateStatus: (s) => true);
  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners(); // Trigger a rebuild
  }

  Future<void> fetchInitialData(BuildContext context) async {
    await Future.wait([getcategory(context), getAllMenus(category: '', context, searchQry: '')]);
  }

  void groupMenusByCategory(BuildContext context) {
    groupedMenuByCategory.clear();

    for (var item in filteredMenu) {
      String category = EasyLocalization.of(context)?.locale == const Locale('en') ? item.itemDesc ?? "" : item.itemDesc ?? "";
      if (groupedMenuByCategory.containsKey(category)) {
        groupedMenuByCategory[category]!.add(item);
      } else {
        groupedMenuByCategory[category] = [item];
      }
    }
  }

  Future<bool> checkIfMenuCodeExist(String itemCode) async {
    try {
      String url = Domain.baseUrl + Domain.CHECKMENUEXIST;
      log("URL : $url");
      var response = await dio.post(url, options: dioOptions, data: {"MENU_CODE": itemCode});
      log("RESPONSE CHECK ITEM CODE ${response.data.toString()}");
      if (response.statusCode == 200) {
        log("TYPE OF DATA ${(response.data)['data'].runtimeType}");
        return response.data['success'];
      } else {
        Singleton.instance.errorMessage = "msg.${response.data['description']}".tr();
        return false;
      }
    } catch (e) {
      log("ERROR GET ALL ITME: ${e.toString()}");
      Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
      return false;
    }
  }

  Color _hexToColor(String hexColor) {
    final String cleanHex = hexColor.toUpperCase().replaceAll('#', '').trim();
    if (cleanHex.length == 6) {
      return Color(int.parse('FF$cleanHex', radix: 16));
    }
    return StyleColor.mainColor;
  }

  Future<void> getMenuStyle(BuildContext context) async {
    if (!_isColorLoading) {
      _isColorLoading = true;
      notifyListeners();
    }
    String url = "${Domain.baseUrl}${Domain.GET_STYLE_MENU}/$_dbCode";
    try {
      final response = await dio.get(url, options: dioOptions);

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['success'] == true && responseData['data'] != null) {
          final styleData = responseData['data'] as Map<String, dynamic>;
          final String? colorHex = styleData['color'] as String?;

          if (colorHex != null && colorHex.isNotEmpty) {
            final newColor = _hexToColor(colorHex);
            if (color != newColor) {
              color = newColor;
            } else {
              log("[MenuProvider] Fetched color is same as current: $colorHex");
            }
          } else {
            log("[MenuProvider] Color field missing or empty in API response data.");
          }
        } else {
          log("[MenuProvider] API response 'success' is false or 'data' field is missing.");
        }
      } else {
        log("[MenuProvider] Failed to fetch menu style. Status: ${response.statusCode}, Desc: ${response.data?['description']}");
      }
    } catch (e) {
      Singleton.instance.errorMessage = "msg.Something went wrong".tr();
      ModernPopupDialog.showPopup(context, "msg.Cannot connect to server".tr(), layerContext: 1, success: 0);
    } finally {
      if (_isColorLoading) {
        _isColorLoading = false;
        notifyListeners();
      }
    }
  }

  // Add this new method to the MenuProvider class
  Future<bool> updateMenuQrColor(BuildContext context, Color newColorToSave) async {
    _isColorLoading = true;
    notifyListeners();

    final String colorHex = _colorToHex(newColorToSave);
    final String url = "${Domain.baseUrl}${Domain.UPDATE_STYLE_MENU}";
    final payload = {"dbCode": _dbCode, "color": colorHex};

    try {
      final response = await dio.put(url, data: payload, options: dioOptions);
      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['success'] == true) {
          color = newColorToSave;
          return true;
        } else {
          String errorMsg = responseData['message'] as String? ?? "Failed to update color".tr();
          ModernPopupDialog.showPopup(context, errorMsg, layerContext: 1, success: 0);
        }
      } else {
        String errorMsg = "Server error (${response.statusCode}) while updating color.".tr();
        if (response.data is Map && response.data['message'] != null) {
          errorMsg = response.data['message'];
        } else if (response.data is Map && response.data['description'] != null) {
          errorMsg = "msg.${response.data['description']}".tr();
        }
        ModernPopupDialog.showPopup(context, errorMsg, layerContext: 1, success: 0);
      }
    } catch (e) {
      log(e.toString());
      if (e is DioException) {
        log("${e.response?.data}, Error: ${e.error}");
      }
      ModernPopupDialog.showPopup(context, "msg.Cannot connect to server".tr(), layerContext: 1, success: 0);
    } finally {
      _isColorLoading = false;
      notifyListeners();
    }
    return false;
  }

  String _colorToHex(Color color) {
    return '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
  }

  Future<MenuDetailModel?> getDetailMenu(BuildContext context, String code) async {
    final String menuUrl = Domain.baseUrl + Domain.GET_DETAIL_MENU;

    try {
      var response = await dio.get(menuUrl, queryParameters: {"MENU_CODE": code}, options: dioOptions);

      log("API Response: ${response.data}");

      if (response.statusCode == 200) {
        final menuDetail = MenuDetailModel.fromJson(response.data);
        menuDetailItems = menuDetail;
        notifyListeners();
        return menuDetail;
      } else {
        String errorMessage = response.data is Map && response.data['description'] != null
            ? "msg.${response.data['description']}".tr()
            : "msg.Unknown error (Status: ${response.statusCode})".tr();

        log("Error response: ${response.data}");
        Singleton.instance.errorMessage = errorMessage;
        ModernPopupDialog.showPopup(context, errorMessage, layerContext: 2, success: 0);
        return null;
      }
    } catch (e) {
      log("Exception occurred: ${e.toString()}");
      Singleton.instance.errorMessage = "msg.Something went wrong".tr();
      ModernPopupDialog.showPopup(context, "msg.Cannot connect to server".tr(), layerContext: 2, success: 0);
      return null;
    }
  }

  void filterItems(BuildContext context, String query) {
    if (query.isEmpty) {
      filteredMenu = menuItems;
    } else {
      filteredMenu = menuItems
          .where((item) => item.itemCode.toLowerCase().contains(query.toLowerCase()) || item.itemDesc!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    groupMenusByCategory(context);
    notifyListeners();
  }

  Future<List<MenuModel>> getAllMenus(
    BuildContext context, {
    String? searchQry,
    String? category,
    int page = 1,
    int limit = 100,
    String menuStat = "A",
  }) async {
    final String menuUrl = Domain.baseUrl + Domain.GET_ALL_MENU;
    final String dbCode = Singleton.instance.getDbCode() ?? '';

    log("  menu:  DB code${dbCode.toString()}");
    final queryParameters = {
      "dbcode": dbCode,
      "page": page,
      "limit": limit,
      if (searchQry != null && searchQry.isNotEmpty) "searchQry": searchQry,
      if (category != null && category.isNotEmpty) "category": category,
      "MENU_STAT": menuStat,
    };
    try {
      var response = await dio.get(queryParameters: queryParameters, menuUrl, options: dioOptions);

      if (response.statusCode == 200) {
        menuItems = (response.data["data"] as List).map((item) => MenuModel.fromJson(item)).toList();
        filteredMenu = menuItems;
        notifyListeners();
        return menuItems;
      } else {
        String errorMessage;
        if (response.data is Map && response.data['description'] is String) {
          errorMessage = "msg.${response.data['description']}".tr();
        } else {
          errorMessage = "msg.Unknown error (Status: ${response.statusCode})".tr();
        }

        Singleton.instance.errorMessage = errorMessage;
        ModernPopupDialog.showPopup(context, errorMessage, layerContext: 2, success: 0);
        return [];
      }
    } catch (e) {
      log("ERROR  menu: ${e.toString()}");
      Singleton.instance.errorMessage = "msg.Something went wrong".tr();
      ModernPopupDialog.showPopup(context, "msg.Cannot connect to server".tr(), layerContext: 2, success: 0);
      return [];
    }
  }

  Future<List<MenuModel>> getAllMenusWithStock(
    BuildContext context, {
    String? searchQry,
    String? category,
    int page = 1,
    int limit = 20,
    String menuStat = "A",
  }) async {
    final String menuUrl = Domain.baseUrl + Domain.GET_ALL_MENU_STOCK;
    final queryParameters = {
      "page": page,
      "limit": limit,
      if (searchQry != null && searchQry.isNotEmpty) "searchQry": searchQry,
      if (category != null && category.isNotEmpty) "category": category,
      "MENU_STAT": menuStat,
    };
    try {
      var response = await dio.get(queryParameters: queryParameters, menuUrl, options: dioOptions);

      if (response.statusCode == 200) {
        menuItems = (response.data["data"] as List).map((item) => MenuModel.fromJson(item)).toList();
        log("MenuItems:  Get all item successfully $menuItems");
        notifyListeners();
        return menuItems;
      } else {
        String errorMessage;
        if (response.data is Map && response.data['description'] is String) {
          errorMessage = "msg.${response.data['description']}".tr();
        } else {
          errorMessage = "msg.Unknown error (Status: ${response.statusCode})".tr();
        }

        Singleton.instance.errorMessage = errorMessage;
        ModernPopupDialog.showPopup(context, errorMessage, layerContext: 2, success: 0);
        return [];
      }
    } catch (e) {
      log("ERROR fetching menu: ${e.toString()}");
      Singleton.instance.errorMessage = "msg.Something went wrong".tr();
      ModernPopupDialog.showPopup(context, "msg.Cannot connect to server".tr(), layerContext: 2, success: 0);
      return [];
    }
  }

  Future<void> getcategory(BuildContext context) async {
    try {
      String url = Domain.baseUrl + Domain.GET_ALL_MENU;
      log("Fetching menu item from: $url");

      var response = await dio.get(url, options: dioOptions);

      if (response.statusCode == 200) {
        // Model_category menuItem = Model_category.fromJson(response.data);
        // category = menuItem.data!.categories!;
        // log("Menu item category successfully: $menuItem");
      }
    } catch (e) {
      log("ERROR fetching menu item by category: ${e.toString()}");
      Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
      ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 1, success: 0);
    }
  }
}
