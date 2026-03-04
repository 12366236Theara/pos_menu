import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_menu/API/domainame.dart';
import 'package:pos_menu/Infrastructor/modernAnimateLoading.dart';
import 'package:pos_menu/Infrastructor/modernPopupDialog.dart';
import 'package:pos_menu/Infrastructor/providerListener.dart';
import 'package:pos_menu/Infrastructor/singleton.dart';
import 'package:pos_menu/model/cart/salecart_model.dart';
import 'package:pos_menu/model/sale/sale_invoice_model.dart';

class SaleProvider extends ChangeNotifier {
  SaleProvider({BuildContext? context});
  var dio = Singleton.instance.dio;
  String selectTableName = "";
  String? selectedTransRef;
  String? orderDateTime;
  String customerCode = "";
  String numberGuest = "1";
  Options dioOptions = Options(receiveDataWhenStatusError: true, followRedirects: false, validateStatus: (s) => true);

  // Options dioOptions = Options(
  //   receiveDataWhenStatusError: true,
  //   headers: {'Content-Type': 'application/json'},
  //   followRedirects: false,
  //   validateStatus: (s) {
  //     return true;
  //   },
  // );

  List<SaleCartModel?> listSaleCart = [];
  Map<String, int> stockOldOnOrder = {};

  void testNotify() {
    notifyListeners();
  }

  SaleInvoiceModel? saleInvoice;

  // void clearSaleOrderData() {
  //   listSaleCart.clear();
  //   stockOldOnOrder.clear();
  //   selectedTransRef = null;
  //   orderDateTime = null;
  //   notifyListeners();
  // }

  Future<SaleInvoiceModel?> postOrder({required BuildContext context, required Map<String, dynamic> body}) async {
    ModernAnimateLoading().showLoading(context, "Loading...".tr());
    log("Post Order Body: ${jsonEncode(body)}");
    String url = Domain.baseUrl + Domain.CREATE_ORDER;
    // try {
    var response = await dio
        .post(url, options: dioOptions, data: jsonEncode(body))
        .catchError(
          (err) => {
            Navigator.pop(context),
            ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 2, success: 0),
          },
        );
    if (response.statusCode == 200) {
      // clearSaleOrderData();

      ProviderListener providerListener = Provider.of<ProviderListener>(context, listen: false);
      providerListener.allItemInSaleCartQty = 0;
      providerListener.saleCartItems.clear();
      providerListener.saleTotalPrice = 0;
      providerListener.saleforedisPrice = 0;
      providerListener.notifyListeners();
      saleInvoice = SaleInvoiceModel.fromJson(response.data['data']);
      // String? selectedTempCartId = Singleton.instance.selectedTempCartId;
      // await Provider.of<TableNotifier>(context, listen: false).getAllTables(context, category: 'All', searchQuery: "");
      // if (selectedTempCartId != null) Provider.of<ProviderListener>(context, listen: false).deleteCartById(selectedTempCartId);
      Navigator.pop(context, true);
      await ModernPopupDialog.showPopup(context, "msg.លក់បានជោគជ័យ".tr(), layerContext: 1, success: 1);

      return saleInvoice;
    } else if (response.statusCode == 400) {
      final msgKey = response.data['description'];
      final tableCode = response.data['data']?['tableCode'];

      final message = "msg.$msgKey".tr(namedArgs: {'tableCode': tableCode?.toString() ?? ''});

      Singleton.instance.errorMessage = message;

      ModernPopupDialog.showPopup(context, message, layerContext: 3, success: 0);

      return null;
    } else {
      Singleton.instance.errorMessage = "msg.${response.data['description']}".tr();
      ModernPopupDialog.showPopup(context, "msg.មានអ្វីមួយមិនប្រក្រតី".tr(), layerContext: 2, success: 0);
      return null;
    }
    // } catch (e) {
    //   log("Error In postOrder: ${e.toString()}");
    //   Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
    //   PopupDialog.showPopup(
    //     context,
    //     "msg.មានអ្វីមួយមិនប្រក្រតី".tr(),
    //     layerContext: 2,
    //     success: 0,
    //    ,
    //   );
    //   return null;
    // }
  }

  Future<bool> updateSaleOrder({required BuildContext context, required Map<String, dynamic> body}) async {
    ModernAnimateLoading().showLoading(context, "Loading...".tr());
    try {
      String url = Domain.baseUrl + Domain.UPDATE_SALE_ORDER_QR;

      var response = await dio
          .post(url, options: dioOptions, data: jsonEncode(body))
          .catchError(
            (err) => {
              Navigator.pop(context),
              ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 2, success: 0),
            },
          );

      if (response.statusCode == 200) {
        ProviderListener providerListener = Provider.of<ProviderListener>(context, listen: false);
        providerListener.allItemInSaleCartQty = 0;
        providerListener.saleCartItems.clear();
        providerListener.saleTotalPrice = 0;
        providerListener.saleforedisPrice = 0;
        providerListener.notifyListeners();
        // saleInvoice = SaleInvoice.fromJson(response.data['data']);
        Navigator.pop(context, true);
        await ModernPopupDialog.showPopup(context, "msg.លក់បានជោគជ័យ".tr(), layerContext: 1, success: 1);

        return true;
      } else if (response.statusCode == 400) {
        Singleton.instance.errorMessage = "msg.${response.data['description']}".tr();
        ModernPopupDialog.showPopup(context, "msg.${response.data['description']}".tr(), layerContext: 2, success: 0);
        return false;
      } else {
        Singleton.instance.errorMessage = "msg.${response.data['description']}".tr();
        ModernPopupDialog.showPopup(context, "msg.មានអ្វីមួយមិនប្រក្រតី".tr(), layerContext: 2, success: 0);
        return false;
      }
    } catch (e) {
      log("Error In Create Sale Order: ${e.toString()}");
      Navigator.pop(context);
      Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
      ModernPopupDialog.showPopup(context, "msg.មានអ្វីមួយមិនប្រក្រតី".tr(), layerContext: 2, success: 0);
      return false;
    }
  }

  Future<bool?> getSaleOrderByTableCode({required BuildContext context, required Map<String, dynamic> queryParams}) async {
    try {
      String url = Domain.baseUrl + Domain.GET_SALE_ORDER;
      log('get table by code url: $url');
      log('get table by code params: $queryParams');
      var response = await dio.get(url, options: dioOptions, queryParameters: queryParams);

      if (response.statusCode == 200) {
        if (response.data['data'] != null && response.data['data'].isNotEmpty) {
          listSaleCart = SaleCartModel.fromList(response.data['data']);
          stockOldOnOrder = _extractOldStockFromOrder(response.data);
        }
        log('Sale Order Data: ${response.data}');
        final numGuest = response.data['NUM_GUEST'] ?? 0;

        final cutcode = response.data['CUST_CODE'] ?? 0;
        List<String> codeTable = List<String>.from(response.data['TABLE'] ?? []);

        selectedTransRef = response.data['TRANS_REF'];
        orderDateTime = response.data['TRANS_DATE'];

        numberGuest = numGuest.toString();
        customerCode = cutcode.toString();
        // tableProvider.selectTableFromApi(codeTable);
        // selectedTableName = tableProvider.selectedTables.map((table) => table.name ?? table.code).whereType<String>().toList();
        ProviderListener providerListener = Provider.of<ProviderListener>(context, listen: false);
        if (listSaleCart.isNotEmpty) {
          providerListener.clearCart();
          providerListener.addToSaleCartList(listSaleCart);
        }

        notifyListeners();
        return true;
      } else {
        Singleton.instance.errorMessage = "msg.${response.data['data']}".tr();
        ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 1, success: 0);
      }
    } catch (e) {
      log("Error in getSaleOrderByTableCode: ${e.toString()}");
      Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
      ModernPopupDialog.showPopup(context, "msg.មានអ្វីមួយមិនប្រក្រតី".tr(), layerContext: 1, success: 0);
    }
    return null;
  }

  Map<String, int> _extractOldStockFromOrder(Map<String, dynamic> orderData) {
    Map<String, int> oldStockMap = {};

    try {
      if (orderData['success'] == true && orderData['data'] != null) {
        List<dynamic> menuItems = orderData['data'] as List<dynamic>;

        for (var menuItem in menuItems) {
          // Get the order count (quantity of this menu item)
          int orderCount = menuItem['ORDER_COUNT'] ?? 1;

          // Get base menu ingredients
          List<dynamic>? ingredients = menuItem['INGREDIENTS'] as List<dynamic>?;
          if (ingredients != null) {
            for (var ing in ingredients) {
              String itemCode = ing['ITEM_CODE'] ?? '';
              int qty = (ing['QTY'] ?? 0).toInt();

              if (itemCode.isNotEmpty) {
                // Multiply by ORDER_COUNT
                oldStockMap[itemCode] = (oldStockMap[itemCode] ?? 0) + (qty * orderCount);
              }
            }
          }

          // Get ingredients from selected options
          List<dynamic>? groupOptions = menuItem['GROUP_OPTIONS'] as List<dynamic>?;
          if (groupOptions != null) {
            for (var group in groupOptions) {
              List<dynamic>? groupDetails = group['GROUP_DETAIL'] as List<dynamic>?;
              if (groupDetails != null) {
                for (var detail in groupDetails) {
                  List<dynamic>? optChoices = detail['OPT_CHOICES'] as List<dynamic>?;
                  if (optChoices != null) {
                    for (var choice in optChoices) {
                      bool isSelected = choice['IS_SELECTED'] ?? false;
                      if (isSelected) {
                        List<dynamic>? choiceIngs = choice['CHOICE_INGS'] as List<dynamic>?;
                        if (choiceIngs != null) {
                          for (var choiceIng in choiceIngs) {
                            String ingCode = choiceIng['ING_CODE'] ?? '';
                            int qty = (choiceIng['QTY'] ?? 0).toInt();

                            if (ingCode.isNotEmpty) {
                              // Multiply by ORDER_COUNT
                              oldStockMap[ingCode] = (oldStockMap[ingCode] ?? 0) + (qty * orderCount);
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    } catch (e) {
      log('Error extracting old stock: $e');
    }

    return oldStockMap;
  }
}
