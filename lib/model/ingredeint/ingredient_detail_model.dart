import 'dart:convert';

import 'package:collection/collection.dart';

class IngredientsDetail {
  final String? itemDesc;
  final String? itemType;
  final num? itemPrice1;
  final num? itemDcost;
  final String? itemLookup;
  final num? physical;
  final num? onOrder;
  final num? total;

  const IngredientsDetail({this.itemDesc, this.itemType, this.itemPrice1, this.itemDcost, this.itemLookup, this.physical, this.onOrder, this.total});

  @override
  String toString() {
    return 'IngredientsDetail(itemDesc: $itemDesc, itemType: $itemType, physical: $physical, onOrder: $onOrder, total: $total)';
  }

  factory IngredientsDetail.fromMap(Map<String, dynamic> data) {
    return IngredientsDetail(
      itemDesc: data['ITEM_DESC'] as String?,
      itemType: data['ITEM_TYPE'] as String?,
      itemPrice1: data['ITEM_PRICE1'] as num?,
      itemDcost: data['ITEM_DCOST'] as num?,
      itemLookup: data['ITEM_LOOKUP'] as String?,
      physical: data['PHYSICAL'] as num?,
      onOrder: data['ON_ORDER'] as num?,
      total: data['TOTAL'] as num?,
    );
  }

  Map<String, dynamic> toMap() => {
    'ITEM_DESC': itemDesc,
    'ITEM_TYPE': itemType,
    'ITEM_PRICE1': itemPrice1,
    'ITEM_DCOST': itemDcost,
    'ITEM_LOOKUP': itemLookup,
    'PHYSICAL': physical,
    'ON_ORDER': onOrder,
    'TOTAL': total,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [IngredientsDetail].
  factory IngredientsDetail.fromJson(String data) {
    return IngredientsDetail.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [IngredientsDetail] to a JSON string.
  String toJson() => json.encode(toMap());

  IngredientsDetail copyWith({String? itemDesc, String? itemType, num? physical, num? onOrder, num? total}) {
    return IngredientsDetail(
      itemDesc: itemDesc ?? this.itemDesc,
      itemType: itemType ?? this.itemType,
      physical: physical ?? this.physical,
      onOrder: onOrder ?? this.onOrder,
      total: total ?? this.total,
    );
  }
}
