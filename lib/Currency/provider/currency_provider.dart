import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pos_menu/API/domainame.dart';
import 'package:pos_menu/Currency/model/currency_mode.dart';
import 'package:pos_menu/Infrastructor/modernPopupDialog.dart';
import 'package:pos_menu/Infrastructor/singleton.dart';

class CurrencyProvider extends ChangeNotifier {
  var dio = Singleton.instance.dio;
  List<CurrencyModel> allCurrenctList = [];

  // Future<bool> postCurrency({required BuildContext context, required Map<String, dynamic> data, File? image}) async {
  //   try {
  //     String url = Domain.baseUrl + Domain.CREATE_CURRENCY;
  //     // Singleton.instance.dioBearerSecondTokenInitialize();

  //     var formData = FormData.fromMap({"data": jsonEncode(data)});

  //     if (image != null) {
  //       formData.files.add(MapEntry("photo", MultipartFile.fromFileSync(image.path)));
  //     }

  //     var response = await dio.post(url, data: formData);

  //     if (response.statusCode == 200) {
  //       await PopupDialog.showPopup(context, "msg.បង្កើតបានជោគជ័យ".tr(), layerContext: 2, success: 1, dismiss: true);
  //       await getAllCurrency(context: context, status: 'A');
  //       return true;
  //     } else if (response.statusCode == 409) {
  //       PopupDialog.showPopup(context, "មានរួចហើយ".tr(), layerContext: 2, success: 1, dismiss: true);
  //       return false;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     PopupDialog.showPopup(
  //       context,
  //       "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(),
  //       layerContext: 1,
  //       success: 0,
  //       soundEffectSuccess: 0,
  //     );
  //     Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
  //     return false;
  //   }
  // }

  // Future<bool> updateCurrency({required BuildContext context, required Map<String, dynamic> data, File? image}) async {
  //   try {
  //     String url = Domain.baseUrl + Domain.UPDATE_CURRENCY;
  //     Singleton.instance.dioBearerSecondTokenInitialize();

  //     var formData = FormData.fromMap({"data": jsonEncode(data)});

  //     if (image != null) {
  //       formData.files.add(MapEntry("photo", MultipartFile.fromFileSync(image.path)));
  //     }

  //     var response = await dio.put(url, data: formData);

  //     if (response.statusCode == 200) {
  //       await getAllCurrency(context: context, status: 'A');
  //       PopupDialog.showPopup(context, "msg.បង្កើតបានជោគជ័យ".tr(), layerContext: 2, success: 1, dismiss: true);

  //       return true;
  //     } else if (response.statusCode == 409) {
  //       PopupDialog.showPopup(context, "មានរួចហើយ".tr(), layerContext: 2, success: 1, dismiss: true);
  //       return false;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     PopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 1, success: 0, soundEffectSuccess: 0);
  //     Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
  //     return false;
  //   }
  // }

  Future<bool> getAllCurrency({required BuildContext context, String? status}) async {
    try {
      String url = Domain.baseUrl + Domain.CREATE_CURRENCY;
      // Singleton.instance.dioBearerSecondTokenInitialize();

      var response = await dio.get(url, data: {"status": status});
      if (response.statusCode == 200) {
        allCurrenctList = CurrencyModel.currencyModelFromJson(response.data['data']);
        // allCurrenctList.insert(0, CurrencyModel(dataCode: "NONE", dataName: "NONE"));
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("ERROR CURRENCY : $e");
      ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 1, success: 0);
      Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
      return false;
    }
  }

  Future<bool> disable({required BuildContext context, String? id, String? status}) async {
    try {
      String confirmMessage = status == "D" ? "msg.តើអ្នកចង់លុបរូបិយប័ណ្ណនេះមែនទេ?".tr() : "msg.តើអ្នកចង់ស្ដារឡើងវិញមែនទេ?".tr();

      bool confirm = await ModernPopupDialog.yesNoPrompt(context, content: confirmMessage);

      if (!confirm) {
        return false;
      }
      String url = Domain.baseUrl + Domain.CREATE_CURRENCY;

      var response = await dio.put(url, data: {"ID": id, "status": status});

      if (response.statusCode == 200) {
        String message = status == "D" ? "msg.លុបបានជោគជ័យ".tr() : "msg.ស្ដារឡើងវិញបានជោគជ័យ".tr();
        ModernPopupDialog.showPopup(Singleton.instance.dashboardContext!, message, layerContext: 1, success: 1);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("ERROR CURRENCY : $e");
      ModernPopupDialog.showPopup(context, "msg.មិនអាចភ្ជាប់ទៅកាន់ប្រព័ន្ធបានទេ".tr(), layerContext: 1, success: 0);
      Singleton.instance.errorMessage = "msg.មានអ្វីមួយមិនប្រក្រតី".tr();
      return false;
    }
  }
}
