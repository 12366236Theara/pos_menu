import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:pos_menu/model/category/category_model.dart';
import 'package:pos_menu/model/ingredeint/ingredient_detail_model.dart';
import 'package:pos_menu/model/ingredeint/ingredient_model.dart';
import 'package:pos_menu/model/menu/menu_option_model.dart';
import 'package:pos_menu/model/menu/option_choices_model.dart';

class MenuModel {
  final String? dbCode;
  String itemCode;
  String? itemBcode;
  String? itemDesc;
  num? itemPrice;
  num? itemStorePrice;
  num? discountPrice;
  String? itemType;
  num? itemDcost;
  String? unitStock;
  String? unitSale;
  num? unitWeight;
  String? itemStat;
  String? transPres;
  String? userCrea;
  String? userUpdt;
  String? userCode;
  String? catCode;
  CategoryModel? category;
  String? itemImg;
  String? location;
  num? physical;
  num? onOrder;
  num? orderCount;
  num? total;
  num? totalDiscountPerItem; // DISCOUNT per item  : សម្រាប់បញ្ចុះតម្លៃក្នុងមួយមុខទំនិញ
  double? totalDisoninv;
  // num? discountItem;
  num? percentItem;
  num? count;
  num? guest;
  num? transval;
  List<Ingredient>? ingredients;
  List<MenuOption>? menuOpts;
  String? configKey;
  int? cookingStatus; // 0 Pending , 1 In Progress , 2 Completed , 3 FAILED
  int? queue;
  String? createdAt;

  MenuModel({
    this.dbCode,
    required this.itemCode,
    this.itemBcode,
    this.itemDesc,
    this.itemPrice,
    this.discountPrice,
    this.itemType,
    this.itemDcost,
    this.unitStock,
    this.unitSale,
    this.unitWeight,
    this.itemStat,
    this.transPres,
    this.userCrea,
    this.userUpdt,
    this.userCode,
    this.count = 0,
    this.catCode,
    this.category,
    this.itemImg,
    this.location,
    this.physical,
    this.onOrder,
    this.orderCount,
    this.total,
    this.totalDisoninv,
    this.totalDiscountPerItem,
    this.itemStorePrice,
    // this.discountItem,
    this.percentItem,
    this.guest,
    this.transval,
    this.ingredients,
    this.menuOpts,
    this.configKey,
    this.cookingStatus,
    this.queue,
    this.createdAt,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      guest: json['NUM_GUEST']?.toInt() ?? 0,
      dbCode: json['DB_CODE']?.toString() ?? '',
      itemCode: json['ITEM_CODE']?.toString() ?? '',
      itemBcode: json['ITEM_BCODE']?.toString() ?? '',
      itemDesc: json['ITEM_DESC']?.toString() ?? '',
      totalDiscountPerItem: json['TOTAL_DISCOUNT']?.toDouble() ?? 0.0,
      itemPrice: (() {
        final v = json['ITEM_PRICE1'];
        if (v == null) return 0.0;
        if (v is num) return v.toDouble();
        if (v is String) return double.tryParse(v) ?? 0.0;
        return 0.0;
      })(),
      itemType: json['ITEM_TYPE']?.toString() ?? '',
      itemDcost: (() {
        final v = json['ITEM_DCOST'];
        if (v == null) return 0.0;
        if (v is num) return v.toDouble();
        if (v is String) return double.tryParse(v) ?? 0.0;
        return 0.0;
      })(),
      unitStock: json['UNIT_STOCK']?.toString() ?? '',
      unitSale: json['UNIT_SALE']?.toString() ?? '',
      unitWeight: (json['UNIT_WEIGHT'] as num?)?.toDouble() ?? 0.0,
      itemStat: json['ITEM_STAT']?.toString() ?? '',
      transPres: json['TRANS_PRES']?.toString() ?? '',
      userCrea: json['USER_CREA']?.toString() ?? '',
      userUpdt: json['USER_UPDT']?.toString() ?? '',
      userCode: json['USER_CODE']?.toString() ?? '',
      catCode: json['CAT_CODE']?.toString(),
      // category: json['category'] != null ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>) : null,
      itemImg: json['ITEM_IMG']?.toString() ?? '',
      location: json['LOCATION']?.toString(),
      physical: (json['PHYSICAL'] as num?) ?? 0,
      onOrder: (json['ON_ORDER'] as num?) ?? 0,
      orderCount: (json['ORDER_COUNT'] as num?) ?? 0,
      total: (json['TOTAL'] as num?) ?? 0,
      totalDisoninv: (json['TOTAL_DISONINV'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['DISCOUNT'] as num?) ?? 0,
      // discountItem: (json['DISCOUNT'] as num?) ?? 0,
      percentItem: (json['DI_PERCENT'] as num?) ?? 0,
      transval: (json['TRANS_VAL'] as num?) ?? 0,
      ingredients: (json['INGREDIENTS'] != null) ? Ingredient.fromList((json['INGREDIENTS'])) : null,
      menuOpts: (json['GROUP_OPTIONS'] != null) ? MenuOption.fromGroupOptions(json['GROUP_OPTIONS'] ?? []) as List<MenuOption>? : null,
      configKey: json['CONFIG_KEY']?.toString() ?? '',
      cookingStatus: json['COOKSTATUS'] ?? 0,
      queue: json['QUEUE'] ?? 0,
      createdAt: json['CREATED_AT'] ?? "",
    );
  }

  Map<String, dynamic> toJson({bool selectedOnly = true}) {
    final map = {
      'DB_CODE': dbCode,
      'ITEM_CODE': itemCode,
      'ITEM_BCODE': itemBcode,
      'ITEM_DESC': itemDesc,
      'ITEM_PRICE1': itemPrice,
      'DISCOUNT': discountPrice == null ? 0 : double.parse(discountPrice!.toStringAsFixed(2)),
      'ITEM_TYPE': itemType,
      'ITEM_DCOST': itemDcost,
      'UNIT_STOCK': unitStock,
      'UNIT_SALE': unitSale,
      'UNIT_WEIGHT': unitWeight,
      'ITEM_STAT': itemStat,
      'TRANS_PRES': transPres,
      'USER_CREA': userCrea,
      'USER_UPDT': userUpdt,
      'USER_CODE': userCode,
      'CAT_CODE': catCode,
      'ITEM_IMG': itemImg,
      'LOCATION': location,
      'PHYSICAL': physical,
      'ON_ORDER': onOrder,
      'TOTAL': total,
      // 'DISCOUNT': discountItem,
      'DI_PERCENT': percentItem,
      'INGREDIENTS': getMenuOptionIngredients(),
      'COOKING_STATUS': cookingStatus ?? 0,
      'QUEUE': queue,
      'CREATED_AT': createdAt,
    };

    final filtered = menuOpts
        ?.where((opt) => (opt.optChoices ?? []).any((c) => c.isSelected == true))
        .map((opt) => opt.toMap(selectedOnly: selectedOnly))
        .toList();

    if (filtered != null && filtered.isNotEmpty) {
      map['GROUP_OPTIONS'] = filtered;
    }

    return map;
  }

  Map<String, dynamic> toJsonInVoice({bool selectedOnly = true}) {
    final map = {
      'DB_CODE': dbCode,
      'ITEM_CODE': itemCode,
      'ITEM_BCODE': itemBcode,
      'ITEM_DESC': itemDesc,
      'ITEM_PRICE1': itemPrice,
      'DISCOUNT': discountPrice == null ? 0 : double.parse(discountPrice!.toStringAsFixed(2)),
      'ITEM_TYPE': itemType,
      'ITEM_DCOST': itemDcost,
      'UNIT_STOCK': unitStock,
      'UNIT_SALE': unitSale,
      'UNIT_WEIGHT': unitWeight,
      'ITEM_STAT': itemStat,
      'TRANS_PRES': transPres,
      'USER_CREA': userCrea,
      'USER_UPDT': userUpdt,
      'USER_CODE': userCode,
      'CAT_CODE': catCode,
      'ITEM_IMG': itemImg,
      'LOCATION': location,
      'PHYSICAL': physical,
      'ON_ORDER': onOrder,
      'TOTAL': total,
      // 'DISCOUNT': discountItem,
      'DI_PERCENT': percentItem,
      'INGREDIENTS': getMenuOptionIngredientsInVoice(),
      'COOKING_STATUS': cookingStatus ?? 0,
      'QUEUE': queue,
      'CREATED_AT': createdAt,
    };

    final filtered = menuOpts
        ?.where((opt) => (opt.optChoices ?? []).any((c) => c.isSelected == true))
        .map((opt) => opt.toMap(selectedOnly: selectedOnly))
        .toList();

    if (filtered != null && filtered.isNotEmpty) {
      map['GROUP_OPTIONS'] = filtered;
    }

    return map;
  }

  Map<String, dynamic> toCloseShiftJson() {
    final map = {
      'ItemCode': itemCode,
      'ItemDesc': itemDesc,
      'Price': '\$ $itemPrice',
      'Qty': orderCount,
      'DiscountPrice': totalDiscountPerItem == null ? 0 : "\$ $totalDiscountPerItem",
      'TOTAL': '\$ $total',
    };

    return map;
  }

  static List<MenuModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => MenuModel.fromJson(e)).toList();
  }

  static String toJsonList(List<MenuModel> items) {
    return jsonEncode(items.map((e) => e.toJson()).toList());
  }

  MenuModel copyWith({
    String? dbCode,
    String? itemCode,
    String? itemBcode,
    String? itemDesc,
    double? itemPrice,
    double? itemStorePrice,
    String? itemType,
    double? itemDcost,
    String? unitStock,
    String? unitSale,
    double? unitWeight,
    String? itemStat,
    String? transPres,
    String? userCrea,
    String? userUpdt,
    String? userCode,
    num? percentItem,
    num? discountItem,
    String? catCode,
    CategoryModel? category,
    String? itemImg,
    String? location,
    int? physical,
    int? onOrder,
    int? orderCount,
    int? total,
    int? count,
    int? guest,
    List<Ingredient>? ingredients,
    List<MenuOption>? menuOpts,
    String? configKey,
    int? cookingStatus,
    int? queue,
    String? createdAt,
  }) {
    return MenuModel(
      dbCode: dbCode ?? this.dbCode,
      itemCode: itemCode ?? this.itemCode,
      itemBcode: itemBcode ?? this.itemBcode,
      itemDesc: itemDesc ?? this.itemDesc,
      itemPrice: itemPrice ?? this.itemPrice,
      itemType: itemType ?? this.itemType,
      itemDcost: itemDcost ?? this.itemDcost,
      unitStock: unitStock ?? this.unitStock,
      unitSale: unitSale ?? this.unitSale,
      unitWeight: unitWeight ?? this.unitWeight,
      itemStat: itemStat ?? this.itemStat,
      itemStorePrice: itemStorePrice ?? this.itemStorePrice,
      transPres: transPres ?? this.transPres,
      userCrea: userCrea ?? this.userCrea,
      userUpdt: userUpdt ?? this.userUpdt,
      userCode: userCode ?? this.userCode,
      catCode: catCode ?? this.catCode,
      category: category ?? this.category,
      itemImg: itemImg ?? this.itemImg,
      location: location ?? this.location,
      physical: physical ?? this.physical,
      onOrder: onOrder ?? this.onOrder,
      orderCount: orderCount ?? this.orderCount,
      total: total ?? this.total,
      count: count ?? this.count,
      guest: guest ?? this.guest,
      percentItem: percentItem ?? this.percentItem,
      discountPrice: discountItem ?? discountPrice,
      ingredients: ingredients ?? this.ingredients,
      menuOpts: menuOpts ?? this.menuOpts,
      configKey: configKey ?? this.configKey,
      transval: transval ?? transval,
      cookingStatus: cookingStatus ?? 0,
      queue: queue ?? 0,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  List<Ingredient> getMenuOptionIngredients() {
    final Map<String, Ingredient> combined = {};

    void addIngredient(Ingredient ing) {
      final code = ing.ingredientCode;
      if (combined.containsKey(code)) {
        final existing = combined[code]!;
        combined[code!] = Ingredient(ingredientCode: code, qty: (existing.qty ?? 0) + (ing.qty ?? 0), ingredientsDetail: existing.ingredientsDetail);
      } else {
        combined[code!] = ing;
      }
    }

    for (final ing in ingredients ?? []) {
      addIngredient(ing);
    }

    for (final opt in menuOpts ?? const <MenuOption>[]) {
      for (final choice in opt.optChoices ?? const <OptChoice>[]) {
        if (choice.isSelected == true && choice.choiceIngs != null) {
          for (final c in choice.choiceIngs!) {
            final detail = IngredientsDetail(
              itemDcost: c.ingdetails?.itemDcost ?? 0,
              itemDesc: c.ingdetails?.itemDesc ?? '',
              itemType: c.ingdetails?.itemType ?? '',
              itemPrice1: c.ingdetails?.itemPrice1 ?? 0,
              itemLookup: c.ingdetails?.itemLookup ?? '',
              physical: c.ingdetails?.physical ?? 0,
              onOrder: c.ingdetails?.onOrder ?? 0,
              total: c.ingdetails?.total ?? 0,
            );
            final ing = Ingredient(ingredientCode: c.ingCode, qty: c.qty, ingredientsDetail: detail);
            addIngredient(ing);
          }
        }
      }
    }

    return combined.values.toList();
  }

  List<Ingredient> getMenuOptionIngredientsInVoice() {
    final Map<String, Ingredient> combined = {};

    void addIngredient(Ingredient ing) {
      final code = ing.ingredientCode;
      if (combined.containsKey(code)) {
        final existing = combined[code]!;
        combined[code!] = Ingredient(ingredientCode: code, qty: (existing.qty ?? 0) + (ing.qty ?? 0), ingredientsDetail: existing.ingredientsDetail);
      } else {
        combined[code!] = ing;
      }
    }

    for (final ing in ingredients ?? []) {
      addIngredient(ing);
    }

    for (final opt in menuOpts ?? const <MenuOption>[]) {
      for (final choice in opt.optChoices ?? const <OptChoice>[]) {
        if (choice.choiceIngs != null) {
          for (final c in choice.choiceIngs!) {
            final detail = IngredientsDetail(
              itemDcost: c.ingdetails?.itemDcost ?? 0,
              itemDesc: c.ingdetails?.itemDesc ?? '',
              itemType: c.ingdetails?.itemType ?? '',
              itemPrice1: c.ingdetails?.itemPrice1 ?? 0,
              itemLookup: c.ingdetails?.itemLookup ?? '',
              physical: c.ingdetails?.physical ?? 0,
              onOrder: c.ingdetails?.onOrder ?? 0,
              total: c.ingdetails?.total ?? 0,
            );
            final ing = Ingredient(ingredientCode: c.ingCode, qty: c.qty, ingredientsDetail: detail);
            addIngredient(ing);
          }
        }
      }
    }

    return combined.values.toList();
  }

  String getMenuCookingStatus(int cookingStatus) {
    switch (cookingStatus) {
      case 0:
        return "រង់ចាំ";
      case 1:
        return "កំពុងចម្អិន";
      case 2:
        return "បញ្ចប់រួចរាល់";
      case 3:
        return "កក់";
      default:
        return "";
    }
  }
}

List<MenuOption> cloneMenuOpts(List<MenuOption>? src) {
  if (src == null) return [];
  return src
      .map(
        (opt) => opt.copyWith(
          optChoices: opt.optChoices
              ?.map((c) => c.copyWith()) // clone OptChoice
              .toList(),
        ),
      )
      .toList();
}

String buildConfigKey(String itemCode, String cookingStatus, String queue, List<MenuOption>? menuOpts) {
  final pairs = <String>[
    for (final opt in menuOpts ?? const <MenuOption>[])
      for (final ch in opt.optChoices ?? const <OptChoice>[])
        if (ch.isSelected == true) '${opt.groupCode}:${ch.choiceCode}',
  ];

  if (pairs.isEmpty) return '$itemCode|$cookingStatus|$queue';

  pairs.sort();
  return '$itemCode|$cookingStatus|$queue|${pairs.join(' | ')}';
}

bool sameConfiguration(MenuModel a, String aKey, MenuModel b, String bKey) {
  if (aKey != bKey) return false;
  final deepEq = const DeepCollectionEquality().equals;
  return deepEq(a.menuOpts, b.menuOpts);
}
