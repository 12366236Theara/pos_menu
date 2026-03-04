import 'dart:convert';

class ExchangeRate {
  final String? vatIn;
  final String? vatOut;
  final String? exchangeRate;
  final String? exchangeRateDisplay;

  const ExchangeRate({this.vatIn, this.vatOut, this.exchangeRate, this.exchangeRateDisplay});

  @override
  String toString() {
    return 'ExchangeRate(vatIn: $vatIn, vatOut: $vatOut, exchangeRate: $exchangeRate)';
  }

  factory ExchangeRate.fromMap(Map<String, dynamic> data) => ExchangeRate(
    vatIn: data['VAT_IN'] as String?,
    vatOut: data['VAT_OUT'] as String?,
    exchangeRate: data['EXCHANGE_RATE'] as String?,
    exchangeRateDisplay: data['EXCHANGE_RATE_DISPLAY'] as String?,
  );

  Map<String, dynamic> toMap() => {'VAT_IN': vatIn, 'VAT_OUT': vatOut, 'EXCHANGE_RATE': exchangeRate, 'EXCHANGE_RATE_DISPLAY': exchangeRateDisplay};

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
}
