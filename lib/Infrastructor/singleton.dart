import 'dart:convert';
import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pos_menu/Currency/model/currency_mode.dart';
import 'package:pos_menu/model/cache/user_cache_model.dart';
import 'package:pos_menu/model/store/exchange_rate_model.dart';
import 'package:pos_menu/model/store/store_model.dart';
import 'package:pos_menu/model/user/all_user_model.dart';
import 'package:pos_menu/model/user/user_model.dart';

class Singleton {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  BuildContext? dashboardContext;
  factory Singleton() {
    return instance;
  }

  static final Singleton instance = Singleton.internal();
  Singleton.internal() {
    log('Instance Singleton Created.');
  }

  // Dio dio = Dio()..options.headers = {"Authorization": dotenv.get("BEARER_TOKEN")};
  final dio = Dio();
  String errorMessage = "";

  Decimal? currencyRate;
  String currencyType = "USD";
  double? currencyRateDisplay;
  String currencyTypeDisplay = "KHR";

  String db_code = '';
  String get dbcode => db_code;
  void setDbCode(String code) {
    db_code = code;
    log("db code set : $code");
  }

  String? getDbCode() => db_code;
  // Shop
  StoreModel? shopInfo;
  // User
  UserModel? userPreset;
  UserModel? sellerPreset;
  UserCacheModel userAccountCache = UserCacheModel();
  AllUserModel? allUsers;
  bool isUserLoginCache = false;

  Future saveExchangeRate({required ExchangeRate exchangeRate}) async {
    try {
      await storage.write(key: 'exhangeRate', value: jsonEncode(exchangeRate.toMap()));
    } catch (ex) {
      log("ERROR SAVE EXCHANGE RATE : $ex");
    }
  }

  Future saveCurrency({required AppCurrency appCurr}) async {
    try {
      await storage.write(key: 'AppCurrency', value: jsonEncode(appCurr.toJon()));
    } catch (ex) {
      log("ERROR SAVE AppCurrency : $ex");
    }
  }
}
