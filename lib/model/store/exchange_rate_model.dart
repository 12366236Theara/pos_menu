import 'dart:convert';

class ExchangeRate {
  String? code;
  String? siData;

  ExchangeRate({this.code, this.siData});

  @override
  String toString() => 'ExchangeRate(code: $code, siData: $siData)';

  factory ExchangeRate.fromMap(Map<String, dynamic> data) => ExchangeRate(code: data['CODE'] as String?, siData: data['SI_DATA'] as String?);

  Map<String, dynamic> toMap() => {'CODE': code, 'SI_DATA': siData};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ExchangeRate].
  factory ExchangeRate.fromJson(String data) {
    return ExchangeRate.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ExchangeRate] to a JSON string.
  String toJson() => json.encode(toMap());

  ExchangeRate copyWith({String? code, String? siData}) {
    return ExchangeRate(code: code ?? this.code, siData: siData ?? this.siData);
  }
}
