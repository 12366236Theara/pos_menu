
class CurrencyModel {
    int? id;
    String? dbCode;
    String? dataCode;
    String? dataName;
    dynamic dataDesc;
    String? dataType;
    String? rate;
    String? note;
    String? status;
    String? image;
    bool? primary;

    CurrencyModel({
        this.id,
        this.dbCode,
        this.dataCode,
        this.dataName,
        this.dataDesc,
        this.dataType,
        this.rate,
        this.note,
        this.status,
        this.image,
        this.primary,
    });


    static List<CurrencyModel> currencyModelFromJson(List<dynamic> jsonList) => jsonList.map((x) => CurrencyModel.fromJson(x)).toList();


    factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        id: json["ID"],
        dbCode: json["DB_CODE"],
        dataCode: json["DATA_CODE"],
        dataName: json["DATA_NAME"],
        dataDesc: json["DATA_DESC"],
        dataType: json["DATA_TYPE"],
        rate: json["FIELD_1"],
        note: json["FIELD_2"],
        status: json["FIELD_3"],
        image: json["image"],
        primary: json["PRIMARY_CURRENCY"] == 'true'
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "DB_CODE": dbCode,
        "DATA_CODE": dataCode,
        "DATA_NAME": dataName,
        "DATA_DESC": dataDesc,
        "DATA_TYPE": dataType,
        "FIELD_1": rate,
        "FIELD_2": note,
        "FIELD_3":status,
        "image": image,
    };
}

class AppCurrency{
  double? currencyRate;
  String? currencyType = "USD";
  double? currencyRateDisplay;
  String? currencyTypeDisplay = "KHR";

  AppCurrency({this.currencyRate,this.currencyRateDisplay, this.currencyType, this.currencyTypeDisplay});

  factory AppCurrency.fromJson(Map<String, dynamic> json) => 
    AppCurrency(
      currencyRate : json['currencyRate'], 
      currencyRateDisplay: json['currencyRateDisplay'], 
      currencyType: json['currencyType'], 
      currencyTypeDisplay: json['currencyTypeDisplay']
    );

  Map<String , dynamic> toJon() => {
    "currencyRate":currencyRate,
    "currencyType":currencyType,
    "currencyRateDisplay":currencyRateDisplay,
    "currencyTypeDisplay":currencyTypeDisplay
  };
}
