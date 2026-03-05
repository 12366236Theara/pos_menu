class InvoiceSettingModel {
  bool? showName;
  bool? showVat;
  bool? showReceive;
  bool? showRemain;
  bool? showNote;
  bool? showCustomerTel;
  bool? showCustomerLoc;
  bool? showImage;
  bool? showDiscount;
  String? description;
  String? papperSize;
  int? spacing;
  int? fontSize;
  int? numberDigits;
  bool? showLed;
  String? qr_label;
  String? qr_invoice;

  InvoiceSettingModel({
    this.showName,
    this.showVat,
    this.showReceive,
    this.showRemain,
    this.showNote,
    this.showCustomerTel,
    this.showCustomerLoc,
    this.showImage,
    this.description,
    this.papperSize,
    this.spacing,
    this.fontSize,
    this.showDiscount,
    this.numberDigits,
    this.qr_label,
    this.qr_invoice,
    this.showLed
  });

  @override
  String toString() {
    return 'InvoiceSettingModel(showName: $showName, showVat: $showVat, showReceive: $showReceive, description: $description,numberDigits: $numberDigits)';
  }

  factory InvoiceSettingModel.fromJson(Map<String, dynamic> json) {
    return InvoiceSettingModel(
      showName: json['SHOW_NAME'] as bool?,
      showVat: json['SHOW_VAT'] as bool?,
      showReceive: json['SHOW_RECEIVE'] as bool?,
      showRemain: json['SHOW_REMAIN'] as bool?,
      showNote: json['SHOW_NOTE'] as bool?,
      showCustomerTel: json['SHOW_CUST_TEL'] as bool?,
      showCustomerLoc: json['SHOW_CUST_LOC'] as bool?,
      showImage: json['SHOW_IMG'] as bool?,
      showDiscount: json['SHOW_DISCOUNT'] as bool?,
      description: json['DESCRIPTION'] as String?,
      papperSize: (json['PAPPER_SIZE'] as num?)?.toString(),
      spacing: (json['SPACING'] as num?)?.toInt(),
      fontSize: (json['FONT_SIZE'] as num?)?.toInt(),
      numberDigits: int.tryParse(json['NUMBER_DIGITS']?.toString() ?? ""),
      qr_invoice: json['QR_INVOICE'] as String?,
      qr_label: json['QR_LABEL'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'SHOW_NAME': showName,
        'SHOW_VAT': showVat,
        'SHOW_RECEIVE': showReceive,
        'SHOW_REMAIN': showRemain,
        'DESCRIPTION': description,
        'SHOW_NOTE': showNote,
        'SHOW_CUST_TEL': showCustomerTel,
        'SHOW_CUST_LOC': showCustomerLoc,
        'SHOW_IMG': showImage,
        'PAPPER_SIZE': papperSize,
        'SPACING': spacing,
        'FONT_SIZE': fontSize,
        'SHOW_DISCOUNT': showDiscount,
        'NUMBER_DIGITS': numberDigits
      };

  InvoiceSettingModel copyWith({
    bool? showName,
    bool? showVat,
    bool? showReceive,
    String? description,
    bool? showRemain,
    bool? showNote,
    bool? showCustomerTel,
    bool? showCustomerLoc,
    bool? showImage,
  }) {
    return InvoiceSettingModel(
      showName: showName ?? this.showName,
      showVat: showVat ?? this.showVat,
      showReceive: showReceive ?? this.showReceive,
      description: description ?? this.description,
      showRemain: showRemain ?? this.showRemain,
      showNote: showNote ?? this.showNote,
      showCustomerTel: showCustomerTel ?? this.showCustomerTel,
      showCustomerLoc: showCustomerLoc ?? this.showCustomerLoc,
      showImage: showImage ?? this.showImage,
    );
  }
}
