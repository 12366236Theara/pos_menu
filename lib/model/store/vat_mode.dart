import 'dart:convert';

class Vat {
  String? code;
  String? siData;

  Vat({this.code, this.siData});

  @override
  String toString() => 'Vat(code: $code, siData: $siData)';

  factory Vat.fromMap(Map<String, dynamic> data) => Vat(
        code: data['CODE'] as String?,
        siData: data['SI_DATA'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'CODE': code,
        'SI_DATA': siData,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Vat].
  factory Vat.fromJson(String data) {
    return Vat.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Vat] to a JSON string.
  String toJson() => json.encode(toMap());

  Vat copyWith({
    String? code,
    String? siData,
  }) {
    return Vat(
      code: code ?? this.code,
      siData: siData ?? this.siData,
    );
  }
}
