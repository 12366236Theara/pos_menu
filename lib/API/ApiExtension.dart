// ignore_for_file: invalid_return_type_for_catch_error, use_build_context_synchronously

import 'dart:developer';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos_menu/API/domainame.dart';
import 'package:pos_menu/Infrastructor/modernAnimateLoading.dart';
import 'package:pos_menu/Infrastructor/modernPopupDialog.dart';
import 'package:pos_menu/Infrastructor/singleton.dart';
import 'package:pos_menu/model/store/exchange_rate_model.dart';
import 'package:pos_menu/model/store/store_model.dart';
import 'package:pos_menu/model/user/user_model.dart';

class ApiExtension with ChangeNotifier {
  ApiExtension({BuildContext? context});

  BuildContext? backupContext;

  var dio = Singleton.instance.dio;
  final String dbCode = Singleton.instance.getDbCode() ?? '';
  ShopData? shopData;
  StoreModel? shopInfo;
  Options dioOptions = Options(
    receiveDataWhenStatusError: true,
    followRedirects: false,
    validateStatus: (s) {
      return true;
    },
  );

  Future<bool> getConnection(BuildContext context, {bool noLoading = false}) async {
    if (!noLoading) {
      ModernAnimateLoading().showLoading(context, 'status.កំពុងដំណើរការ'.tr());
    }
    String url = "${Domain.baseUrl}/auth/getconnection";
    final res = await dio
        .get(
          url,
          options: Options(
            receiveDataWhenStatusError: true,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 505;
            },
          ),
        )
        .catchError((err) {
          log("GET CONNECTION ERROR ${err.toString()}");
          backupContext = context;
          if (!noLoading) {
            Navigator.pop(context);
            ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅប្រព័ន្ធ".tr(), success: 0);
          }
          return false;
        });
    if (res.statusCode == 200) {
      if (!noLoading) Navigator.pop(context);
      return true;
    } else {
      return false;
    }
  }

  Future<UserModel?> getUserById(BuildContext context, {required String id}) async {
    try {
      String url = Domain.baseUrl + Domain.GET_USER_BY_ID;
      var response = await dio.get(url, options: dioOptions, queryParameters: {"USER_ID": id});
      log("GET USER BY ID RESPONSE ${response.data}");
      if (response.statusCode == 200) {
        var userEntity = UserModel.fromJson(response.data['data']);
        Singleton.instance.sellerPreset = userEntity;
        notifyListeners();
        return userEntity;
      } else {
        Singleton.instance.errorMessage = "msg.${response.data['description']}".tr();
        return null;
      }
    } catch (e) {
      log("ERROR GET USER By id: ${e.toString()}");
      Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
      // PopupDialog.showPopup(context, "msg.មានអ្វីមួយមិនប្រក្រតី".tr(),
      //     success: 0);
      return null;
    }
  }

  // Future<bool> getUserProfile(BuildContext context) async {
  //   try {
  //     String url = Domain.baseUrl + Domain.USER_PROFILE_URL;
  //     var response = await dio.get(url, options: dioOptions, queryParameters: ({'': dbCode}));
  //     if (response.statusCode == 200) {
  //       Singleton.instance.userPreset = UserModel.fromJson((response.data['data']));
  //       notifyListeners();
  //       return true;
  //     } else {
  //       Singleton.instance.errorMessage = "msg.${response.data['description']}".tr();
  //       return false;
  //     }
  //   } catch (e) {
  //     Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
  //     ModernPopupDialog.showPopup(context, "msg.មានអ្វីមួយមិនប្រក្រតី".tr(), success: 0);
  //     return false;
  //   }
  // }

  Future<bool> getShopInfo() async {
    try {
      String url = Domain.baseUrl + Domain.GET_SHOP_INFO;
      var res = await dio.get(url, options: dioOptions);

      if (res.statusCode == 200) {
        Singleton.instance.shopInfo = StoreModel.fromMap(res.data['data']);
        log("GET SHOP INFO : ${Singleton.instance.shopInfo?.toJson()}");

        ///base
        Singleton.instance.currencyType = Singleton.instance.shopInfo?.exchangeRate?.last.code ?? "USD";
        Singleton.instance.currencyRate = Decimal.parse(Singleton.instance.shopInfo?.exchangeRate?.last.siData ?? "0");
        //secodary
        Singleton.instance.currencyTypeDisplay = Singleton.instance.shopInfo?.exchangeRate?.first.code ?? "USD";
        Singleton.instance.currencyRateDisplay = double.parse(Singleton.instance.shopInfo?.exchangeRate!.first.siData ?? "0");

        // save for daul screen
        Singleton.instance.saveExchangeRate(
          exchangeRate: ExchangeRate(
            exchangeRate: Singleton.instance.currencyRate.toString(),
            exchangeRateDisplay: Singleton.instance.currencyRateDisplay.toString(),
          ),
        );

        Singleton.instance.saveCurrency(
          appCurr: AppCurrency(
            currencyRate: Singleton.instance.currencyRate?.toDouble(),
            currencyRateDisplay: Singleton.instance.currencyRateDisplay,
            currencyType: Singleton.instance.currencyType,
            currencyTypeDisplay: Singleton.instance.currencyTypeDisplay,
          ),
        );

        notifyListeners();
        return true;
      } else {
        Singleton.instance.errorMessage = "msg.${res.data["description"]}";
        return false;
      }
    } on DioException catch (err) {
      log("ERROR GET SHOP INFO : $err");
      Singleton.instance.errorMessage = "msg.Operation Failed";
      return false;
    } catch (err) {
      log("GET Shop Response Error: $err");
      Singleton.instance.errorMessage = err.toString();
      return false;
    }
  }
}
