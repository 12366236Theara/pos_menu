class ItemCurr {
  double? currValues;
  String? type;
  double? currRate;

  ItemCurr({this.currValues, this.type, this.currRate});

  factory ItemCurr.fromJson(Map<String, dynamic> json) => ItemCurr(
    currValues: (json["CURR_VALUES"] is String)
        ? double.tryParse(json["CURR_VALUES"])
        : (json["CURR_VALUES"] is int)
        ? (json["CURR_VALUES"] as int).toDouble()
        : json["CURR_VALUES"] as double?,
    type: json["TYPE"],
    currRate: (json["FIELD_1"] is String) ? double.tryParse(json["FIELD_1"]) : json["FIELD_1"],
  );

  Map<String, dynamic> toJson() => {"CURR_VALUES": currValues, "TYPE": type, "CURR_RATE": currRate};
}
