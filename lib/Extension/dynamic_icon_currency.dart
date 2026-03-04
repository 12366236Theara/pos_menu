import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pos_menu/Infrastructor/singleton.dart';

class CurrencyExtention {
  CurrencyExtention._();

  static String? _cachedIcon;

  static String currencyIcon() {
    if (_cachedIcon != null) return _cachedIcon!;
    CurrencyCode code = CurrencyCode.values.where((e) => e.name.contains(Singleton.instance.currencyType)).firstOrNull ?? CurrencyCode.USD;
    _cachedIcon = getCurrencySymbolENUM(code);
    return _cachedIcon!;
  }

  static String currencyIconSecond({String? currencyCode}) {
    CurrencyCode code =
        CurrencyCode.values.where((e) => e.name.contains(currencyCode ?? Singleton.instance.currencyTypeDisplay)).firstOrNull ?? CurrencyCode.USD;
    return getCurrencySymbolENUM(code);
  }
}

extension FixedCurrencyFormatter on num {
  String toFixedCurrency({String locale = 'en_US'}) {
    final symbol = CurrencyExtention.currencyIcon();
    num value = this;
    int digit = 2;

    switch (symbol) {
      case '៛':
        digit = 0;
        value = (this / 100).ceil() * 100;
        break;
      case '\$':
        digit = Singleton.instance.shopInfo?.invoiceSetting?.numberDigits ?? 2;
        break;
    }

    final format = NumberFormat.currency(locale: locale, symbol: symbol, decimalDigits: digit);

    String formatted = format.format(value);

    if (!formatted.startsWith('$symbol ')) {
      formatted = formatted.replaceFirst(symbol, '$symbol ');
    }

    return formatted;
  }

  String toFixedCurrencySeconde({String locale = 'en_US'}) {
    final symbol = CurrencyExtention.currencyIconSecond();
    num value = this;
    int digit = 2;

    switch (symbol) {
      case '៛':
        digit = 0;
        value = (this / 100).ceil() * 100;

        break;
      case '\$':
        digit = Singleton.instance.shopInfo?.invoiceSetting?.numberDigits ?? 2;
        break;
    }

    final format = NumberFormat.currency(locale: locale, symbol: symbol, decimalDigits: digit);

    String formatted = format.format(value);

    if (!formatted.startsWith('$symbol ')) {
      formatted = formatted.replaceFirst(symbol, '$symbol ');
    }

    return formatted;
  }
}

class CurrencyTextSecond extends StatelessWidget {
  final String price;
  final TextStyle? style;
  final TextAlign? textAlign;

  const CurrencyTextSecond({required this.price, this.style, this.textAlign = TextAlign.start, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(double.parse(price).toFixedCurrencySeconde(), style: style, textAlign: textAlign, overflow: TextOverflow.ellipsis);
  }
}

class CurrencyText extends StatelessWidget {
  final Decimal price;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow overflow;

  const CurrencyText({required this.price, this.style, this.textAlign = TextAlign.start, this.overflow = TextOverflow.ellipsis, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(price.toDouble().toFixedCurrency(), style: style, textAlign: textAlign, overflow: TextOverflow.ellipsis);
  }
}
