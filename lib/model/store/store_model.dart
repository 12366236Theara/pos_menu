import 'dart:convert';

import 'package:pos_menu/model/store/exchange_rate_model.dart';
import 'package:pos_menu/model/store/vat_mode.dart';

class StoreModel {
  String? dbCode;
  String? dbName;
  String? dateDefault;
  String? dateFormat;
  int? saDecimal;
  int? sbDecicma;
  String? decSep;
  String? thoSep;
  String? dbStat;
  String? userCrea;
  String? dateCrea;
  String? userUpdt;
  String? dateUpdt;
  String? map;
  String? dbLoc;
  List<Vat>? vat;
  List<ExchangeRate>? exchangeRate;
  // List<QueueModel>? queue;
  // InvoiceSettingModel? invoiceSetting;
  String? defaultCurrency;
  String? qr_imagPath;
  String? qr_inv_1;
  String? qr_inv_2;

  StoreModel({
    this.dbCode,
    this.dbName,
    this.dateDefault,
    this.dateFormat,
    this.saDecimal,
    this.sbDecicma,
    this.decSep,
    this.thoSep,
    this.dbStat,
    this.userCrea,
    this.dateCrea,
    this.userUpdt,
    this.dateUpdt,
    this.map,
    this.dbLoc,
    this.vat,
    this.exchangeRate,
    // this.queue,
    // this.invoiceSetting,
    this.qr_inv_1,
    this.qr_inv_2,
    this.qr_imagPath,
    this.defaultCurrency,
  });

  @override
  String toString() {
    return 'StoreModel(dbCode: $dbCode, dbName: $dbName, dateDefault: $dateDefault, dateFormat: $dateFormat, saDecimal: $saDecimal, sbDecicma: $sbDecicma, decSep: $decSep, thoSep: $thoSep, dbStat: $dbStat, userCrea: $userCrea, dateCrea: $dateCrea, userUpdt: $userUpdt, dateUpdt: $dateUpdt, map: $map, dbLoc: $dbLoc, vat: $vat, exchangeRate: $exchangeRate)';
  }

  factory StoreModel.fromMap(Map<String, dynamic> data) => StoreModel(
    dbCode: data['DB_CODE'] as String?,
    dbName: data['DB_NAME'] as String?,
    dateDefault: data['DATE_DEFAULT'] as String?,
    dateFormat: data['DATE_FORMAT'] as String?,
    saDecimal: data['SA_DECIMAL'] as int?,
    sbDecicma: data['SB_DECICMA'] as int?,
    decSep: data['DEC_SEP'] as String?,
    thoSep: data['THO_SEP'] as String?,
    dbStat: data['DB_STAT'] as String?,
    userCrea: data['USER_CREA'] as String?,
    dateCrea: data['DATE_CREA'] as String?,
    userUpdt: data['USER_UPDT'] as String?,
    dateUpdt: data['DATE_UPDT'] as String?,
    map: data['MAP'] as String?,
    qr_inv_1: data['qr_inv_1'],
    qr_inv_2: data['qr_inv_2'],
    dbLoc: data['DB_LOC'] as String?,
    vat: (data['VAT'] as List<dynamic>?)?.map((e) => Vat.fromMap(e as Map<String, dynamic>)).toList(),
    exchangeRate: (data['EXCHANGE_RATE'] as List<dynamic>?)?.map((e) => ExchangeRate.fromMap(e as Map<String, dynamic>)).toList(),
    // queue: (data['QUEUE'] as List<dynamic>?)?.map((e) => QueueModel.fromMap(e as Map<String, dynamic>)).toList(),
    // invoiceSetting: data['INVOICE_SETTING'] != null ? InvoiceSettingModel.fromJson(data['INVOICE_SETTING'] as Map<String, dynamic>) : null,
    defaultCurrency: data['CURRENCY'] as String?,
    qr_imagPath: (data['QR_IMAGE']),
  );

  Map<String, dynamic> toMap() => {
    'DB_CODE': dbCode,
    'DB_NAME': dbName,
    'DATE_DEFAULT': dateDefault,
    'DATE_FORMAT': dateFormat,
    'SA_DECIMAL': saDecimal,
    'SB_DECICMA': sbDecicma,
    'DEC_SEP': decSep,
    'THO_SEP': thoSep,
    'DB_STAT': dbStat,
    'USER_CREA': userCrea,
    'DATE_CREA': dateCrea,
    'USER_UPDT': userUpdt,
    'DATE_UPDT': dateUpdt,
    'MAP': map,
    'DB_LOC': dbLoc,
    'QR_IMAGE': qr_imagPath,
    'VAT': vat?.map((e) => e.toMap()).toList(),
    'EXCHANGE_RATE': exchangeRate?.map((e) => e.toMap()).toList(),
    // 'QUEUE': queue?.map((e) => e.toMap()).toList(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [StoreModel].
  factory StoreModel.fromJson(String data) {
    return StoreModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [StoreModel] to a JSON string.
  String toJson() => json.encode(toMap());

  StoreModel copyWith({
    String? dbCode,
    String? dbName,
    String? dateDefault,
    String? dateFormat,
    int? saDecimal,
    int? sbDecicma,
    String? decSep,
    String? thoSep,
    String? dbStat,
    String? userCrea,
    String? dateCrea,
    String? userUpdt,
    String? dateUpdt,
    String? map,
    String? dbLoc,
    List<Vat>? vat,
    List<ExchangeRate>? exchangeRate,
  }) {
    return StoreModel(
      dbCode: dbCode ?? this.dbCode,
      dbName: dbName ?? this.dbName,
      dateDefault: dateDefault ?? this.dateDefault,
      dateFormat: dateFormat ?? this.dateFormat,
      saDecimal: saDecimal ?? this.saDecimal,
      sbDecicma: sbDecicma ?? this.sbDecicma,
      decSep: decSep ?? this.decSep,
      thoSep: thoSep ?? this.thoSep,
      dbStat: dbStat ?? this.dbStat,
      userCrea: userCrea ?? this.userCrea,
      dateCrea: dateCrea ?? this.dateCrea,
      userUpdt: userUpdt ?? this.userUpdt,
      dateUpdt: dateUpdt ?? this.dateUpdt,
      map: map ?? this.map,
      dbLoc: dbLoc ?? this.dbLoc,
      vat: vat ?? this.vat,
      exchangeRate: exchangeRate ?? this.exchangeRate,
    );
  }
}
