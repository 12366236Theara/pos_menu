import 'package:pos_menu/model/menu/menu_option_model.dart';

class MenuDetailModel {
  Data? data;
  bool? hasImage;

  MenuDetailModel({this.data, this.hasImage});

  MenuDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    hasImage = json['hasImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['hasImage'] = hasImage;
    return data;
  }
}

class Data {
  MenuItem? menuItem;
  List<Ingredientss>? ingredientss;

  Data({this.menuItem, this.ingredientss});

  Data.fromJson(Map<String, dynamic> json) {
    menuItem = json['menuItem'] != null ? MenuItem.fromJson(json['menuItem']) : null;
    if (json['ingredientss'] != null) {
      ingredientss = <Ingredientss>[];
      json['ingredientss'].forEach((v) {
        ingredientss!.add(Ingredientss.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (menuItem != null) {
      data['menuItem'] = menuItem!.toJson();
    }
    if (ingredientss != null) {
      data['ingredientss'] = ingredientss!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class MenuItem {
  String? dBCODE;
  String? iTEMCODE;
  String? iTEMBCODE;
  String? iTEMDESC;
  String? iTEMLOOKUP;
  String? iTEM_IMG;

  double? iTEMPRICE1;
  double? iTEMDCOST;
  int? iTEMPRICE2;
  int? iTEMPRICE3;
  int? iTEMPRICE4;
  String? iTEMLEVEL;
  String? iTEMTYPE;
  String? uNITSTOCK;
  String? uNITSALE;
  int? uNITWEIGHT;
  String? uPDTPRICE;
  String? pROCCOMP;
  String? iTEMSTAT;
  String? iTEMPRO;
  String? iTEMCUS1;
  String? iTEMCUS2;
  String? iTEMCUS3;
  String? iTEMCUS4;
  String? iTEMCUS5;
  String? iTEMCUS6;
  String? iTEMCUS7;
  String? iTEMCUS8;
  String? iTEMCUS9KH;
  String? iTEMCUS10KH;
  String? tRANSPRES;
  String? uSERCREA;
  String? uSERUPDT;
  String? uSERCODE;
  String? cATCODE;
  Category? category;
  List<MenuOption>? menuOption;

  MenuItem({
    this.iTEM_IMG,
    this.dBCODE,
    this.iTEMCODE,
    this.iTEMBCODE,
    this.iTEMDESC,
    this.iTEMLOOKUP,
    this.iTEMPRICE1,
    this.iTEMPRICE2,
    this.iTEMPRICE3,
    this.iTEMPRICE4,
    this.iTEMLEVEL,
    this.iTEMTYPE,
    this.iTEMDCOST,
    this.uNITSTOCK,
    this.uNITSALE,
    this.uNITWEIGHT,
    this.uPDTPRICE,
    this.pROCCOMP,
    this.iTEMSTAT,
    this.iTEMPRO,
    this.iTEMCUS1,
    this.iTEMCUS2,
    this.iTEMCUS3,
    this.iTEMCUS4,
    this.iTEMCUS5,
    this.iTEMCUS6,
    this.iTEMCUS7,
    this.iTEMCUS8,
    this.iTEMCUS9KH,
    this.iTEMCUS10KH,
    this.tRANSPRES,
    this.uSERCREA,
    this.uSERUPDT,
    this.uSERCODE,
    this.cATCODE,
    this.category,
    this.menuOption,
  });

  MenuItem.fromJson(Map<String, dynamic> json) {
    dBCODE = json['DB_CODE'];
    iTEM_IMG = json['ITEM_IMG'];
    iTEMCODE = json['ITEM_CODE'];
    iTEMBCODE = json['ITEM_BCODE'];
    iTEMDESC = json['ITEM_DESC'];
    iTEMLOOKUP = json['ITEM_LOOKUP'];
    iTEMPRICE1 = _toDouble(json['ITEM_PRICE1']);
    iTEMPRICE2 = json['ITEM_PRICE2'];
    iTEMPRICE3 = json['ITEM_PRICE3'];
    iTEMPRICE4 = json['ITEM_PRICE4'];
    iTEMLEVEL = json['ITEM_LEVEL'];
    iTEMTYPE = json['ITEM_TYPE'];
    iTEMDCOST = _toDouble(json['ITEM_DCOST']);
    uNITSTOCK = json['UNIT_STOCK'];
    uNITSALE = json['UNIT_SALE'];
    uNITWEIGHT = json['UNIT_WEIGHT'];
    uPDTPRICE = json['UPDT_PRICE'];
    pROCCOMP = json['PROC_COMP'];
    iTEMSTAT = json['ITEM_STAT'];
    iTEMPRO = json['ITEM_PRO'];
    iTEMCUS1 = json['ITEM_CUS1'];
    iTEMCUS2 = json['ITEM_CUS2'];
    iTEMCUS3 = json['ITEM_CUS3'];
    iTEMCUS4 = json['ITEM_CUS4'];
    iTEMCUS5 = json['ITEM_CUS5'];
    iTEMCUS6 = json['ITEM_CUS6'];
    iTEMCUS7 = json['ITEM_CUS7'];
    iTEMCUS8 = json['ITEM_CUS8'];
    iTEMCUS9KH = json['ITEM_CUS9_KH'];
    iTEMCUS10KH = json['ITEM_CUS10_KH'];
    tRANSPRES = json['TRANS_PRES'];
    uSERCREA = json['USER_CREA'];
    uSERUPDT = json['USER_UPDT'];
    uSERCODE = json['USER_CODE'];
    cATCODE = json['CAT_CODE'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['GROUP_OPTIONS'] != null) {
      menuOption = MenuOption.fromListJson(json['GROUP_OPTIONS']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DB_CODE'] = dBCODE;
    data['ITEM_CODE'] = iTEMCODE;
    data['ITEM_BCODE'] = iTEMBCODE;
    data['ITEM_DESC'] = iTEMDESC;
    data['ITEM_LOOKUP'] = iTEMLOOKUP;
    data['ITEM_PRICE1'] = iTEMPRICE1;
    data['ITEM_PRICE2'] = iTEMPRICE2;
    data['ITEM_PRICE3'] = iTEMPRICE3;
    data['ITEM_PRICE4'] = iTEMPRICE4;
    data['ITEM_LEVEL'] = iTEMLEVEL;
    data['ITEM_TYPE'] = iTEMTYPE;
    data['ITEM_DCOST'] = iTEMDCOST;
    data['UNIT_STOCK'] = uNITSTOCK;
    data['UNIT_SALE'] = uNITSALE;
    data['UNIT_WEIGHT'] = uNITWEIGHT;
    data['UPDT_PRICE'] = uPDTPRICE;
    data['PROC_COMP'] = pROCCOMP;
    data['ITEM_STAT'] = iTEMSTAT;
    data['ITEM_PRO'] = iTEMPRO;
    data['ITEM_CUS1'] = iTEMCUS1;
    data['ITEM_CUS2'] = iTEMCUS2;
    data['ITEM_CUS3'] = iTEMCUS3;
    data['ITEM_CUS4'] = iTEMCUS4;
    data['ITEM_CUS5'] = iTEMCUS5;
    data['ITEM_CUS6'] = iTEMCUS6;
    data['ITEM_CUS7'] = iTEMCUS7;
    data['ITEM_CUS8'] = iTEMCUS8;
    data['ITEM_CUS9_KH'] = iTEMCUS9KH;
    data['ITEM_CUS10_KH'] = iTEMCUS10KH;
    data['TRANS_PRES'] = tRANSPRES;
    data['USER_CREA'] = uSERCREA;
    data['USER_UPDT'] = uSERUPDT;
    data['USER_CODE'] = uSERCODE;
    data['CAT_CODE'] = cATCODE;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Category {
  String? dESCEN;
  String? dESCKH;
  String? dESCCN;

  Category({this.dESCEN, this.dESCKH, this.dESCCN});

  Category.fromJson(Map<String, dynamic> json) {
    dESCEN = json['DESC_EN'];
    dESCKH = json['DESC_KH'];
    dESCCN = json['DESC_CN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DESC_EN'] = dESCEN;
    data['DESC_KH'] = dESCKH;
    data['DESC_CN'] = dESCCN;
    return data;
  }
}

class Ingredientss {
  String? iTEMCODE;
  String? iTEMDESC;
  String? IMAGE;

  String? uNITSTOCK;
  double? qTY;

  Ingredientss({this.iTEMCODE, this.iTEMDESC, this.uNITSTOCK, this.qTY, this.IMAGE});

  Ingredientss.fromJson(Map<String, dynamic> json) {
    iTEMCODE = json['ITEM_CODE'];
    iTEMDESC = json['ITEM_DESC'];
    IMAGE = json['IMAGE'];

    uNITSTOCK = json['UNIT_STOCK'];

    if (json['QTY'] != null) {
      if (json['QTY'] is int) {
        qTY = (json['QTY'] as int).toDouble();
      } else if (json['QTY'] is double) {
        qTY = json['QTY'];
      } else if (json['QTY'] is String) {
        qTY = double.tryParse(json['QTY']);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ITEM_CODE'] = iTEMCODE;
    data['ITEM_DESC'] = iTEMDESC;
    data['IMAGE'] = IMAGE;
    data['UNIT_STOCK'] = uNITSTOCK;
    data['QTY'] = qTY;
    return data;
  }
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.tryParse(value);
  return null;
}
