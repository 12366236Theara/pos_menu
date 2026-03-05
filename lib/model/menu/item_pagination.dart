import 'dart:convert';

class ItemPagination {
  int? totalItems;
  int? currentPage;
  int? totalPages;

  ItemPagination({this.totalItems, this.currentPage, this.totalPages});

  @override
  String toString() {
    return 'ItemPagination(totalItems: $totalItems, currentPage: $currentPage, totalPages: $totalPages)';
  }

  factory ItemPagination.fromMap(Map<String, dynamic> data) {
    return ItemPagination(totalItems: data['totalItems'] as int?, currentPage: data['currentPage'] as int?, totalPages: data['totalPages'] as int?);
  }

  Map<String, dynamic> toMap() => {'totalItems': totalItems, 'currentPage': currentPage, 'totalPages': totalPages};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ItemPagination].
  factory ItemPagination.fromJson(String data) {
    return ItemPagination.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ItemPagination] to a JSON string.
  String toJson() => json.encode(toMap());
}
