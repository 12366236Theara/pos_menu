import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:pos_menu/API/domainame.dart';
import 'package:pos_menu/Infrastructor/StyleColor.dart';
import 'package:pos_menu/Infrastructor/modernPopupDialog.dart';
import 'package:pos_menu/model/menu/item_pagination.dart';
import 'package:pos_menu/model/menu/menu_detail_model.dart';
import 'package:pos_menu/model/menu/menu_model.dart';

import '../Infrastructor/Singleton.dart';

class ItemProvider extends ChangeNotifier {
  ItemProvider({BuildContext? context}) {
    log("Menu Provider initialized");
  }

  // List<MenuDetailModel> _menuDetailItems = [];
  // List<MenuDetailModel> get menuDetailItems => _menuDetailItems;

  MenuDetailModel? menuDetailItems;
  Map<String, List<MenuModel>> groupedItemsByCategory = {};

  List<MenuModel> items = [];
  ItemPagination? itemPagination;

  List<MenuModel> filteredItems = [];

  List<String> category = [];

  Color color = StyleColor.mainColor;

  final bool _isColorLoading = false;
  bool get isColorLoading => _isColorLoading;

  // var dio = Singleton.instance.dio;
  final dio = Dio();
  // String get _dbCode => Singleton.instance.getDbCode() ?? '';

  Options dioOptions = Options(receiveDataWhenStatusError: true, followRedirects: false, validateStatus: (s) => true);

  Future<List<MenuModel>> getItemWithPagination(
    BuildContext context, {
    String? searchQry,
    String? category,
    int page = 1,
    int limit = 20,
    String itemStat = "A",
    String? suppCode,
    String? itemType = "S",
    required String dbcode,
  }) async {
    try {
      String url = Domain.baseUrl + Domain.GET_ALL_ITEM_WITHPAGINATION_V2;
      final queryParameters = {
        "dbcode": dbcode,
        "page": page,
        "limit": limit,
        if (searchQry != null && searchQry.isNotEmpty) "searchQry": searchQry,
        if (category != null && category.isNotEmpty) "category": category,
      };

      Response response = await dio.get(
        url,
        options: dioOptions,
        queryParameters: queryParameters,
        data: {'ITEM_STAT': itemStat, 'SUPP_CODE': suppCode, 'ITEM_TYPE': itemType},
      );
      log("GET ALL ITEM PAGE: ${response.data}");
      if (response.statusCode == 200) {
        List<MenuModel> fetchedItems = List<MenuModel>.from(response.data['data'].map((element) => MenuModel.fromMap(element)) ?? []);

        itemPagination = ItemPagination.fromMap(response.data['meta'] ?? {});

        if (page == 1) {
          items = fetchedItems;
        } else {
          items.addAll(fetchedItems);
        }

        // Log all display item code

        notifyListeners();
        return fetchedItems;
      } else {
        Singleton.instance.errorMessage = "msg.${response.data['description']}".tr();
        ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 2, success: 0);
        return [];
      }
    } catch (e) {
      log("ERROR GET ALL ITEM PAGE: ${e.toString()}");
      ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 2, success: 0);
      Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
      return [];
    }
  }

  void groupItemsByCategory(BuildContext context) {
    groupedItemsByCategory.clear(); // Clear the map before grouping items

    for (var item in filteredItems) {
      String category = EasyLocalization.of(context)?.locale == const Locale('en') ? item.catDescEn ?? "" : item.catDescKh ?? "";
      if (groupedItemsByCategory.containsKey(category)) {
        groupedItemsByCategory[category]!.add(item);
      } else {
        groupedItemsByCategory[category] = [item];
      }
    }
  }

  void filterItems(BuildContext context, String query) {
    if (query.isEmpty) {
      filteredItems = items;
    } else {
      filteredItems = items
          .where((item) => item.itemCode!.toLowerCase().contains(query.toLowerCase()) || item.itemDesc!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    groupItemsByCategory(context);
    notifyListeners();
  }
}
