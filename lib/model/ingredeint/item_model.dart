import 'dart:convert';

class Item {
  String? dbCode;
  String? itemCode;
  String? itemBcode;
  String? itemDesc;
  String? itemLookup;
  double? itemPrice1;

  int? itemPrice2;
  int? itemPrice3;
  int? itemPrice4;
  String? itemLevel;
  String? itemType;
  double? itemDcost;
  double? itemSuppCost;
  String? unitStock;
  String? unitSale;
  int? unitWeight;
  String? updtPrice;
  String? procComp;
  String? itemStat;
  String? itemPro;
  String? itemCus1;
  String? itemCus2;
  String? itemCus3;
  String? itemCus4;
  String? itemCus5;
  String? itemCus6;
  String? itemCus7;
  String? itemCus8;
  String? itemCus9Kh;
  String? itemCus10Kh;
  String? transPres;
  DateTime? userCrea;
  DateTime? userUpdt;
  String? userCode;
  String? catCode;
  String? catDescEn;
  String? catDescKh;
  String? catDescCn;
  String? itemImg;
  num? physical;
  num? onOrder;
  num? total;
  num? totalSale;

  Item({
    this.dbCode,
    this.itemCode,
    this.itemBcode,
    this.itemDesc,
    this.itemLookup,
    this.itemPrice1,
    this.itemPrice2,
    this.itemPrice3,
    this.itemPrice4,
    this.itemLevel,
    this.itemType,
    this.itemDcost,
    this.itemSuppCost,
    this.unitStock,
    this.unitSale,
    this.unitWeight,
    this.updtPrice,
    this.procComp,
    this.itemStat,
    this.itemPro,
    this.itemCus1,
    this.itemCus2,
    this.itemCus3,
    this.itemCus4,
    this.itemCus5,
    this.itemCus6,
    this.itemCus7,
    this.itemCus8,
    this.itemCus9Kh,
    this.itemCus10Kh,
    this.transPres,
    this.userCrea,
    this.userUpdt,
    this.userCode,
    this.catCode,
    this.catDescEn,
    this.catDescKh,
    this.catDescCn,
    this.itemImg,
    this.physical,
    this.onOrder,
    this.total,
    this.totalSale,
  });

  @override
  String toString() {
    return 'Item(dbCode: $dbCode, itemCode: $itemCode, itemBcode: $itemBcode, itemDesc: $itemDesc, itemLookup: $itemLookup, itemPrice1: $itemPrice1, itemPrice2: $itemPrice2, itemPrice3: $itemPrice3, itemPrice4: $itemPrice4, itemLevel: $itemLevel, itemType: $itemType, itemDcost: $itemDcost, unitStock: $unitStock, unitSale: $unitSale, unitWeight: $unitWeight, updtPrice: $updtPrice, procComp: $procComp, itemStat: $itemStat, itemPro: $itemPro, itemCus1: $itemCus1, itemCus2: $itemCus2, itemCus3: $itemCus3, itemCus4: $itemCus4, itemCus5: $itemCus5, itemCus6: $itemCus6, itemCus7: $itemCus7, itemCus8: $itemCus8, itemCus9Kh: $itemCus9Kh, itemCus10Kh: $itemCus10Kh, transPres: $transPres, userCrea: $userCrea, userUpdt: $userUpdt, userCode: $userCode, catCode: $catCode, catDescEn: $catDescEn, catDescKh: $catDescKh, catDescCn: $catDescCn, itemImg: $itemImg) , physical: $physical , onOrder: $onOrder , total: $total';
  }

  factory Item.fromMap(Map<String, dynamic> data) => Item(
    dbCode: data['DB_CODE'] as String?,
    itemCode: data['ITEM_CODE'] as String?,
    itemBcode: data['ITEM_BCODE'] as String?,
    itemDesc: data['ITEM_DESC'] as String?,
    itemLookup: data['ITEM_LOOKUP'] as String?,
    itemPrice1: (data['ITEM_PRICE1'] as num?)?.toDouble(),
    itemPrice2: data['ITEM_PRICE2'] as int?,
    itemPrice3: data['ITEM_PRICE3'] as int?,
    itemPrice4: data['ITEM_PRICE4'] as int?,
    itemLevel: data['ITEM_LEVEL'] as String?,
    itemType: data['ITEM_TYPE'] as String?,
    itemDcost: (data['ITEM_DCOST'] as num?)?.toDouble(),
    itemSuppCost: (data['SUPP_COST'] as num?)?.toDouble(),
    unitStock: data['UNIT_STOCK'] as String?,
    unitSale: data['UNIT_SALE'] as String?,
    unitWeight: data['UNIT_WEIGHT'] as int?,
    updtPrice: data['UPDT_PRICE'] as String?,
    procComp: data['PROC_COMP'] as String?,
    itemStat: data['ITEM_STAT'] as String?,
    itemPro: data['ITEM_PRO'] as String?,
    itemCus1: data['ITEM_CUS1'] as String?,
    itemCus2: data['ITEM_CUS2'] as String?,
    itemCus3: data['ITEM_CUS3'] as String?,
    itemCus4: data['ITEM_CUS4'] as String?,
    itemCus5: data['ITEM_CUS5'] as String?,
    itemCus6: data['ITEM_CUS6'] as String?,
    itemCus7: data['ITEM_CUS7'] as String?,
    itemCus8: data['ITEM_CUS8'] as String?,
    itemCus9Kh: data['ITEM_CUS9_KH'] as String?,
    itemCus10Kh: data['ITEM_CUS10_KH'] as String?,
    transPres: data['TRANS_PRES'] as String?,
    userCrea: data['USER_CREA'] == null ? null : DateTime.parse(data['USER_CREA'] as String),
    userUpdt: data['USER_UPDT'] == null ? null : DateTime.parse(data['USER_UPDT'] as String),
    userCode: data['USER_CODE'] as String?,
    catCode: data['CAT_CODE'] as String?,
    catDescEn: data['CAT_DESC_EN'] as String?,
    catDescKh: data['CAT_DESC_KH'] as String?,
    catDescCn: data['CAT_DESC_CN'] as String?,
    itemImg: data['ITEM_IMG'] as String?,
    physical: data['PHYSICAL'] as num?,
    onOrder: data['ON_ORDER'] as num?,
    total: data['TOTAL'] as num?,
    totalSale: data['TOTAL_SALE'] as num?,
  );

  Map<String, dynamic> toMap() => {
    'DB_CODE': dbCode,
    'ITEM_CODE': itemCode,
    'ITEM_BCODE': itemBcode,
    'ITEM_DESC': itemDesc,
    'ITEM_LOOKUP': itemLookup,
    'ITEM_PRICE1': itemPrice1,
    'ITEM_PRICE2': itemPrice2,
    'ITEM_PRICE3': itemPrice3,
    'ITEM_PRICE4': itemPrice4,
    'ITEM_LEVEL': itemLevel,
    'ITEM_TYPE': itemType,
    'ITEM_DCOST': itemDcost,
    'UNIT_STOCK': unitStock,
    'UNIT_SALE': unitSale,
    'UNIT_WEIGHT': unitWeight,
    'UPDT_PRICE': updtPrice,
    'PROC_COMP': procComp,
    'ITEM_STAT': itemStat,
    'ITEM_PRO': itemPro,
    'ITEM_CUS1': itemCus1,
    'ITEM_CUS2': itemCus2,
    'ITEM_CUS3': itemCus3,
    'ITEM_CUS4': itemCus4,
    'ITEM_CUS5': itemCus5,
    'ITEM_CUS6': itemCus6,
    'ITEM_CUS7': itemCus7,
    'ITEM_CUS8': itemCus8,
    'ITEM_CUS9_KH': itemCus9Kh,
    'ITEM_CUS10_KH': itemCus10Kh,
    'TRANS_PRES': transPres,
    'USER_CREA': userCrea?.toIso8601String(),
    'USER_UPDT': userUpdt?.toIso8601String(),
    'USER_CODE': userCode,
    'CAT_CODE': catCode,
    'CAT_DESC_EN': catDescEn,
    'CAT_DESC_KH': catDescKh,
    'CAT_DESC_CN': catDescCn,
    'ITEM_IMG': itemImg,
    'PHYSICAL': physical,
    'ON_ORDER': onOrder,
    'TOTAL': total,
    'TOTAL_SALE': totalSale,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Item].
  factory Item.fromJson(String data) {
    return Item.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  static List<Item> fromList(List<dynamic> list) {
    return list.map((item) => Item.fromMap(item as Map<String, dynamic>)).toList();
  }

  /// `dart:convert`
  ///
  /// Converts [Item] to a JSON string.
  String toJson() => json.encode(toMap());

  // Convert from Item to MenuModel
  // MenuModel toMenuModel() {
  //   return MenuModel(
  //     dbCode: dbCode,
  //     itemCode: itemCode ?? "N/A",
  //     itemBcode: itemBcode,
  //     itemDesc: itemDesc,
  //     itemPrice: itemPrice1,
  //     itemType: itemType,
  //     itemDcost: itemDcost,
  //     unitStock: unitStock,
  //     unitSale: unitSale,
  //     unitWeight: double.tryParse(unitWeight?.toString() ?? "0") ?? 0.0,
  //     itemStat: itemStat,
  //     transPres: transPres,
  //     userCrea: userCrea?.toIso8601String(),
  //     userUpdt: userUpdt?.toIso8601String(),
  //     userCode: userCode,
  //     catCode: catCode,
  //     category: CategoryModel(
  //       descCn: catDescCn,
  //       descEn: catDescEn,
  //       descKh: catDescKh,
  //     ),
  //     itemImg: itemImg ?? "",
  //     physical: 9999,
  //     onOrder: 0,
  //     total: 0,
  //   );
  // }
}
