import 'dart:convert';

import 'package:pos_menu/model/ingredeint/ingredient_detail_model.dart';

class Ingredient {
  final String? ingredientCode;
  final num? qty;
  final IngredientsDetail? ingredientsDetail;

  const Ingredient({this.ingredientCode, this.qty, this.ingredientsDetail});

  @override
  String toString() {
    return 'Ingredient(ingredientCode: $ingredientCode, qty: $qty, ingredientsDetail: $ingredientsDetail)';
  }

  @override
  int get hashCode => ingredientCode.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Ingredient) return false;
    return ingredientCode == other.ingredientCode;
  }

  factory Ingredient.fromMap(Map<String, dynamic> data) => Ingredient(
    ingredientCode: data['ITEM_CODE'] as String?,
    qty: data['QTY'] as num?,
    ingredientsDetail: data['INGREDIENTS_DETAIL'] == null ? null : IngredientsDetail.fromMap(data['INGREDIENTS_DETAIL'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toMap() => {'ITEM_CODE': ingredientCode, 'QTY': qty, 'INGREDIENTS_DETAIL': ingredientsDetail?.toMap()};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Ingredient].
  factory Ingredient.fromJson(String data) {
    return Ingredient.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  // fromlist
  static List<Ingredient> fromList(dynamic raw) {
    List<dynamic> list;
    if (raw is String) {
      list = jsonDecode(raw) as List<dynamic>;
    } else if (raw is List) {
      list = raw;
    } else {
      return [];
    }

    return list.map((item) {
      final Map<String, dynamic> data = item is String ? jsonDecode(item) as Map<String, dynamic> : item as Map<String, dynamic>;
      return Ingredient.fromMap(data);
    }).toList();
  }

  /// `dart:convert`
  ///
  /// Converts [Ingredient] to a JSON string.
  String toJson() => json.encode(toMap());

  Ingredient copyWith({String? ingredientCode, int? qty, IngredientsDetail? ingredientsDetail}) {
    return Ingredient(
      ingredientCode: ingredientCode ?? this.ingredientCode,
      qty: qty ?? this.qty,
      ingredientsDetail: ingredientsDetail ?? this.ingredientsDetail,
    );
  }
}
