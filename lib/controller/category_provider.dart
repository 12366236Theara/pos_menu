// ignore_for_file: invalid_return_type_for_catch_error, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:pos_menu/API/domainame.dart';
import 'package:pos_menu/Infrastructor/ModernPopupDialog.dart';
import 'package:pos_menu/Infrastructor/Singleton.dart';
import 'package:pos_menu/Infrastructor/modernAnimateLoading.dart';
import 'package:pos_menu/model/category/category_model.dart';
import 'package:pos_menu/model/ingredeint/item_model.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider({BuildContext? context}) {
    log("BrandNotifier initialized");
  }

  List<CategoryModel> categories = [];
  List<Item> cateogryItem = [];

  var dio = Singleton.instance.dio;
  String get _dbCode => Singleton.instance.getDbCode() ?? '';

  Map<String, List<CategoryModel>> groupedCategorysByCategory = {};

  void setCategory(List<CategoryModel> warehouse) {
    categories = warehouse;
    notifyListeners();
  }

  Options dioOptions = Options(
    receiveDataWhenStatusError: true,
    followRedirects: false,
    validateStatus: (s) {
      return true;
    },
  );

  void testNotify() {
    notifyListeners();
  }

  Future<bool> getCategory(BuildContext context, {String searchQry = "", String categoryType = "M", int status = 1, String? dbcode}) async {
    try {
      String url = Domain.baseUrl + Domain.GET_ALL_CATEGORIES;
      var response = await dio
          .get(
            url,
            options: dioOptions,
            queryParameters: {"searchQry": searchQry, "status": status, "type": categoryType, 'dbcode': dbcode ?? _dbCode},
          )
          .catchError((err) => {ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 2, success: 0)});
      if (response.statusCode == 200) {
        categories = CategoryModel.fromJsonList((response.data)['data']);
        notifyListeners();
        return true;
      } else if (response.statusCode == 400) {
        Singleton.instance.errorMessage = "msg.${response.data['description']}".tr();
        ModernPopupDialog.showPopup(context, "msg.${response.data['description']}".tr(), layerContext: 2, success: 0);
        return false;
      } else {
        Singleton.instance.errorMessage = "msg.${response.data['description']}".tr();
        ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 2, success: 0);
        return false;
      }
    } catch (e) {
      log("ERROR GET CATEGORY: ${e.toString()}");
      ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 2, success: 0);
      Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
      return false;
    }
  }

  Future<bool> getCategoryByBrand(BuildContext context, String brandID) async {
    try {
      String url = Domain.baseUrl + Domain.GET_CATEGORY_BY_BRAND;
      var response = await dio
          .get(url, options: dioOptions, queryParameters: {"BRAND_ID": brandID})
          .catchError((err) => {ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 2, success: 0)});
      if (response.statusCode == 200) {
        categories = CategoryModel.fromJsonList((response.data)['data']);
        log("BEFORE NOTIFY LISTENER EXECUTE");
        notifyListeners();
        log("AFTER NOTIFY LISTENER EXECUTE");
        return true;
      } else {
        Singleton.instance.errorMessage = "msg.${response.data['description']}".tr();
        ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 2, success: 0);
        return false;
      }
    } catch (e) {
      log("ERROR GET CATEGORY: ${e.toString()}");
      ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 2, success: 0);
      Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
      return false;
    }
  }

  Future<List<Item>> getCategoryItem(BuildContext context, String addCode) async {
    try {
      String url = Domain.baseUrl + Domain.GET_CATEGORY_ITEM;
      var response = await dio
          .get(url, options: dioOptions, queryParameters: {"CAT_CODE": addCode})
          .catchError((err) => {ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 2, success: 0)});

      log("GET Category ITEM RESPONSE ${response.data}");
      if (response.statusCode == 200) {
        log("TYPE OF DATA ${(response.data)['data'].runtimeType}");
        // supplierItems = List<SupplierModel>.from(response.data['data']
        //     .map((element) => SupplierModel.fromJson(element)));
        cateogryItem = List<Item>.from(response.data['data'].map((element) => Item.fromMap((element))));

        notifyListeners();
        return cateogryItem;
      } else {
        Singleton.instance.errorMessage = "msg.${response.data['description']}".tr();

        ModernPopupDialog.showPopup(context, "msg.${response.data['description']}".tr(), layerContext: 2, success: 0);
        return [];
      }
    } catch (e) {
      log("ERROR GET ALL Supplier: ${e.toString()}");
      ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 2, success: 0);
      Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
      return [];
    }
  }

  // void getAllCategoryInit(BuildContext context) {
  //   futureGetWarehouse = getCategory(context);
  // }
}
