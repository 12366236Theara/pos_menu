import 'package:pos_menu/model/menu/menu_model.dart';

class SaleInvoiceModel {
  Header? header;
  Customer? customer;
  List<Items>? items;
  List<MenuModel>? menuItems;
  Total? total;

  SaleInvoiceModel({this.header, this.customer, this.items, this.menuItems, this.total});

  SaleInvoiceModel.fromJson(Map<String, dynamic> json) {
    header = json['header'] != null ? Header.fromJson(json['header']) : null;
    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;

    if (json['menus'] != null) {
      menuItems = MenuModel.fromJsonList(json['menus']);
    }
    total = json['total'] != null ? Total.fromJson(json['total']) : null;
  }
  @override
  String toString() {
    return 'SaleInvoiceModel(header: $header, customer: $customer, items: $items, total: $total)';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (header != null) {
      data['header'] = header!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (total != null) {
      data['total'] = total!.toJson();
    }
    return data;
  }
}

class Header {
  String? invoiceNumber;
  String? invoiceDate;
  String? seller;
  String? storeName;
  String? storeTele;
  String? storeImage;
  String? note;
  String? description;
  String? queue;
  String? tableName;

  Header({
    this.invoiceNumber,
    this.invoiceDate,
    this.seller,
    this.storeName,
    this.storeTele,
    this.storeImage,
    this.note,
    this.description,
    this.queue,
    this.tableName,
  });

  Header.fromJson(Map<String, dynamic> json) {
    invoiceNumber = json['invoice_number'] ?? "";
    invoiceDate = json['invoice_date'] ?? "";
    seller = json['seller'] ?? "";
    storeName = json['store_name'] ?? "";
    storeTele = json['store_tele'] ?? "";
    storeImage = json['store_image'] ?? "";
    note = json['note'] ?? "";
    description = json['description'] ?? "";
    if (json['queue'] is String) {
      queue = json['queue'];
    } else if (json['queue'] is num) {
      queue = (json['queue'] as num).toString();
    } else {
      queue = null;
    }
    tableName = json['table_name'] is List ? (json['table_name'] as List).join(', ') : json['table_name']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoice_number'] = invoiceNumber;
    data['invoice_date'] = invoiceDate;
    data['seller'] = seller;
    data['store_name'] = storeName;
    data['store_tele'] = storeTele;
    data['store_image'] = storeImage;
    data['note'] = note;
    data['description'] = description;
    return data;
  }

  @override
  String toString() {
    return 'Header(invoiceNumber: $invoiceNumber, invoiceDate: $invoiceDate, seller: $seller, storeName: $storeName, storeTele: $storeTele , storeImage: $storeImage)';
  }

  void copyWith({required String note, required String? invoiceNumber}) {}
}

class Customer {
  String? aDDNAME;
  String? aDDTEL;
  String? aDDLINE1;
  String? aDDCODE;

  Customer({this.aDDNAME, this.aDDTEL, this.aDDLINE1, this.aDDCODE});

  Customer.fromJson(Map<String, dynamic> json) {
    aDDNAME = json['ADD_NAME'];
    aDDTEL = json['ADD_TEL'];
    aDDLINE1 = json['ADD_LINE_1'];
    aDDCODE = json['ADD_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ADD_NAME'] = aDDNAME;
    data['ADD_TEL'] = aDDTEL;
    data['ADD_LINE_1'] = aDDLINE1;
    data['ADD_CODE'] = aDDCODE;
    return data;
  }

  @override
  String toString() {
    return 'Customer(ADD_NAME: $aDDNAME, ADD_TEL: $aDDTEL, ADD_LINE_1: $aDDLINE1, ADD_CODE: $aDDCODE)';
  }
}

class Items {
  String? iTEMCODE;
  String? iTEMDESC;
  int? fREE;
  double? iTEMPRICE1;
  double? iTEMDCOST;
  int? oRDERCOUNT;
  int? dISCOUNTAMOUNT;
  int? dISCOUNTPERCENT;
  dynamic tARGETQTY;
  String? iTEMLOOKUP;
  double? iTEMTOTAL;
  List<String>? choiceOption;

  Items({
    this.iTEMCODE,
    this.iTEMDESC,
    this.fREE,
    this.iTEMPRICE1,
    this.iTEMDCOST,
    this.oRDERCOUNT,
    this.dISCOUNTAMOUNT,
    this.dISCOUNTPERCENT,
    this.tARGETQTY,
    this.iTEMLOOKUP,
    this.iTEMTOTAL,
    this.choiceOption,
  });

  Items.fromJson(Map<String, dynamic> json) {
    iTEMCODE = json['ITEM_CODE'];
    iTEMDESC = json['ITEM_DESC'];
    fREE = json['FREE'];
    iTEMPRICE1 = (json['ITEM_PRICE1'] is String) ? double.tryParse(json['ITEM_PRICE1']) : json['ITEM_PRICE1'];
    iTEMDCOST = (json['ITEM_DCOST'] is String) ? double.tryParse(json['ITEM_DCOST']) : json['ITEM_DCOST'];
    oRDERCOUNT = json['ORDER_COUNT'];
    dISCOUNTAMOUNT = json['DISCOUNT_AMOUNT'];
    dISCOUNTPERCENT = json['DISCOUNT_PERCENT'];
    tARGETQTY = json['TARGET_QTY'];
    iTEMLOOKUP = json['ITEM_LOOKUP'];
    iTEMTOTAL = (json['ITEM_TOTAL'] is String) ? double.tryParse(json['ITEM_TOTAL']) : json['ITEM_TOTAL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ITEM_CODE'] = iTEMCODE;
    data['ITEM_DESC'] = iTEMDESC;
    data['FREE'] = fREE;
    data['ITEM_PRICE1'] = iTEMPRICE1;
    data['ITEM_DCOST'] = iTEMDCOST;
    data['ORDER_COUNT'] = oRDERCOUNT;
    data['DISCOUNT_AMOUNT'] = dISCOUNTAMOUNT;
    data['DISCOUNT_PERCENT'] = dISCOUNTPERCENT;
    data['TARGET_QTY'] = tARGETQTY;
    data['ITEM_LOOKUP'] = iTEMLOOKUP;
    data['ITEM_TOTAL'] = iTEMTOTAL;
    return data;
  }

  @override
  String toString() {
    return 'Items(ITEM_CODE: $iTEMCODE, ITEM_DESC: $iTEMDESC, FREE: $fREE, ITEM_PRICE1: $iTEMPRICE1, ITEM_DCOST: $iTEMDCOST, ORDER_COUNT: $oRDERCOUNT, DISCOUNT_AMOUNT: $dISCOUNTAMOUNT, DISCOUNT_PERCENT: $dISCOUNTPERCENT, TARGET_QTY: $tARGETQTY, ITEM_LOOKUP: $iTEMLOOKUP, ITEM_TOTAL: $iTEMTOTAL)';
  }
}

class Total {
  double? subTotal;
  double? discount;
  double? vatOut;
  String? total;
  double? totalKh;
  num? exchangeRate;
  num? percent;
  double? subTotalSplit;

  Total({this.subTotal, this.discount, this.vatOut, this.subTotalSplit, this.total, this.totalKh, this.exchangeRate, this.percent});

  Total.fromJson(Map<String, dynamic> json) {
    if (json['sub_total'] is String) {
      subTotal = double.tryParse(json['sub_total']);
    } else if (json['sub_total'] is num) {
      subTotal = (json['sub_total'] as num).toDouble();
    } else {
      subTotal = null;
    }

    // Handle discount which can be String or num
    if (json['discount'] is String) {
      discount = double.tryParse(json['discount']);
    } else if (json['discount'] is num) {
      discount = (json['discount'] as num).toDouble();
    } else {
      discount = null;
    }

    total = json['total']?.toString();
    if (json['vatOut'] is String) {
      vatOut = double.tryParse(json['vatOut']);
    } else if (json['vatOut'] is num) {
      vatOut = (json['vatOut'] as num).toDouble();
    } else {
      vatOut = null;
    }

    if (json['total_kh'] is String) {
      totalKh = double.tryParse(json['total_kh']);
    } else if (json['total_kh'] is num) {
      totalKh = (json['total_kh'] as num).toDouble();
    } else {
      totalKh = null;
    }

    exchangeRate = json['exchange_rate'] is String
        ? double.tryParse(json['exchange_rate'])
        : (json['exchange_rate'] is num ? (json['exchange_rate'] as num).toDouble() : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_total'] = subTotal;
    data['discount'] = discount;
    data['total'] = total;
    data['total_kh'] = totalKh;
    data['exchange_rate'] = exchangeRate;
    data['vat_out'] = vatOut;
    return data;
  }

  @override
  String toString() {
    return 'Total(subTotal: $subTotal, discount: $discount, total: $total)';
  }

  // copy with
  Total copyWith({double? subTotal, double? discount, String? total, double? totalKh, double? exchangeRate, double? vatOut}) {
    return Total(
      subTotal: subTotal ?? this.subTotal,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      totalKh: totalKh ?? this.totalKh,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      vatOut: vatOut ?? this.vatOut,
    );
  }
}
