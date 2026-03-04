import 'dart:convert';

import 'package:pos_menu/model/menu/choices_ing.dart';

class OptChoice {
  String? dbCode;
  String? groupCode;
  String? choiceCode;
  String? choiceName;
  double? price;
  bool? isSelected;
  List<ChoiceIng>? choiceIngs;

  OptChoice({this.dbCode, this.groupCode, this.choiceCode, this.choiceName, this.price, this.isSelected, this.choiceIngs});

  @override
  String toString() {
    return 'OptChoice(dbCode: $dbCode, groupCode: $groupCode, choiceCode: $choiceCode, choiceName: $choiceName, price: $price, choiceIngs: $choiceIngs)';
  }

  factory OptChoice.fromMap(Map<String, dynamic> data) => OptChoice(
    dbCode: data['DB_CODE'] as String?,
    groupCode: data['GROUP_CODE'] as String?,
    choiceCode: data['CHOICE_CODE'] as String?,
    choiceName: data['CHOICE_NAME'] as String?,
    price: (data['PRICE'] as num?)?.toDouble(),
    choiceIngs: (data['CHOICE_INGS'] as List<dynamic>?)?.map((e) => ChoiceIng.fromMap(e as Map<String, dynamic>)).toList(),
    isSelected: (data['IS_SELECTED'] as bool?) ?? false,
  );

  Map<String, dynamic> toMap() => {
    'DB_CODE': dbCode,
    'GROUP_CODE': groupCode,
    'CHOICE_CODE': choiceCode,
    'CHOICE_NAME': choiceName,
    'PRICE': price,
    'CHOICE_INGS': choiceIngs?.map((e) => e.toMap()).toList(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OptChoice].
  factory OptChoice.fromJson(String data) {
    return OptChoice.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OptChoice] to a JSON string.
  String toJson() => json.encode(toMap());

  OptChoice copyWith({
    String? dbCode,
    String? groupCode,
    String? choiceCode,
    String? choiceName,
    double? price,
    bool? isSelected,
    List<ChoiceIng>? choiceIngs,
  }) {
    return OptChoice(
      dbCode: dbCode ?? this.dbCode,
      groupCode: groupCode ?? this.groupCode,
      choiceCode: choiceCode ?? this.choiceCode,
      choiceName: choiceName ?? this.choiceName,
      price: price ?? this.price,
      isSelected: isSelected ?? this.isSelected,
      choiceIngs: choiceIngs ?? this.choiceIngs,
    );
  }
}
