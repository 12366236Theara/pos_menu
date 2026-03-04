class CategoryModel {
  int? id;
  int? cateId;
  String? analysisId;
  String? descKh;
  String? descEn;
  String? descCn;
  DateTime? createdDate;
  String? createdBy;
  int? status;
  String? image;

  CategoryModel({
    this.id,
    this.cateId,
    this.analysisId,
    this.descKh,
    this.descEn,
    this.descCn,
    this.createdDate,
    this.createdBy,
    this.status,
    this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['ID'] as int?,
    cateId: json['CATE_ID'] as int?,
    analysisId: json['ANALYSIS_ID'] as String?,
    descKh: json['DESC_KH'] as String?,
    descEn: json['DESC_EN'] as String?,
    descCn: json['DESC_CN'] as String?,
    createdDate: json['CREATED_DATE'] == null ? null : DateTime.parse(json['CREATED_DATE'] as String),
    createdBy: json['CREATED_BY'] as String?,
    status: json['STATUS'] as int?,
    image: json['image'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'ID': id,
    'CATE_ID': cateId,
    'ANALYSIS_ID': analysisId,
    'DESC_KH': descKh,
    'DESC_EN': descEn,
    'DESC_CN': descCn,
    'CREATED_DATE': createdDate?.toIso8601String(),
    'CREATED_BY': createdBy,
    'STATUS': status,
    'image': image,
  };

  static List<CategoryModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => CategoryModel.fromJson(item)).toList();
  }
}
