import 'dart:convert';

import 'package:pos_menu/model/ingredeint/item_model.dart';

class ChoiceIng {
  String? dbCode;
  String? groupCode;
  String? choiceCode;
  String? ingCode;
  int? qty;
  Item? ingdetails;

  ChoiceIng({this.dbCode, this.groupCode, this.choiceCode, this.ingCode, this.qty, this.ingdetails});

  @override
  String toString() {
    return 'ChoiceIng(dbCode: $dbCode, groupCode: $groupCode, choiceCode: $choiceCode, ingCode: $ingCode, qty: $qty)';
  }

  factory ChoiceIng.fromMap(Map<String, dynamic> data) => ChoiceIng(
    dbCode: data['DB_CODE'] as String?,
    groupCode: data['GROUP_CODE'] as String?,
    choiceCode: data['CHOICE_CODE'] as String?,
    ingCode: data['ING_CODE'] as String?,
    qty: data['QTY'] as int?,
    ingdetails: data['INGREDIENTS'] != null ? Item.fromMap(data['INGREDIENTS'] as Map<String, dynamic>) : null,
  );

  Map<String, dynamic> toMap() => {'DB_CODE': dbCode, 'GROUP_CODE': groupCode, 'CHOICE_CODE': choiceCode, 'ING_CODE': ingCode, 'QTY': qty};

  factory ChoiceIng.fromJson(String data) {
    return ChoiceIng.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  ChoiceIng copyWith({String? dbCode, String? groupCode, String? choiceCode, String? ingCode, int? qty}) {
    return ChoiceIng(
      dbCode: dbCode ?? this.dbCode,
      groupCode: groupCode ?? this.groupCode,
      choiceCode: choiceCode ?? this.choiceCode,
      ingCode: ingCode ?? this.ingCode,
      qty: qty ?? this.qty,
    );
  }
}
