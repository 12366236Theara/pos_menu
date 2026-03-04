import 'dart:convert';

import 'package:pos_menu/model/menu/option_choices_model.dart';

class MenuOption {
  String? groupCode;
  String? groupName;
  String? status;
  bool? isRequired;
  bool? isMultiselect;
  bool? isApplyPrice;
  List<OptChoice>? optChoices;

  MenuOption({this.groupCode, this.groupName, this.status, this.isRequired, this.isMultiselect, this.optChoices, this.isApplyPrice});

  @override
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Returns a string representation of the MenuOption instance, including
  /// all its properties such as groupCode, groupName, status, isRequired,
  /// isMultiselect, and optChoices.
  String toString() {
    return 'MenuOption( groupCode: $groupCode, groupName: $groupName, status: $status, isRequired: $isRequired, isMultiselect: $isMultiselect, optChoices: $optChoices)';
  }

  factory MenuOption.fromMap(Map<String, dynamic> data) {
    return MenuOption(
      groupCode: data['GROUP_CODE'] as String?,
      groupName: data['GROUP_NAME'] as String?,
      status: data['STATUS'] as String?,
      isRequired: data['IS_REQUIRED'] as bool?,
      isMultiselect: data['IS_MULTISELECT'] as bool?,
      isApplyPrice: data['TYPE'] as bool?,
      optChoices: (data['OPT_CHOICES'] as List<dynamic>?)?.map((e) => OptChoice.fromMap(e as Map<String, dynamic>)).toList(),
      // optChoices: (data['GROUP_DETAIL'] as List<dynamic>?)?.map((e) => OptChoice.fromMap(e as Map<String, dynamic>)).toList(),
    );
  }

  static List<MenuOption> fromGroupOptions(List<dynamic> groupOptionsJson) {
    List<MenuOption> allOptions = [];

    for (var groupOption in groupOptionsJson) {
      final groupDetail = groupOption['GROUP_DETAIL'];
      if (groupDetail is Map<String, dynamic>) {
        allOptions.add(MenuOption.fromMap(groupDetail));
      } else if (groupDetail is List<dynamic>) {
        allOptions.addAll(groupDetail.map((e) => MenuOption.fromMap(e as Map<String, dynamic>)));
      }
    }
    return allOptions;
  }

  Map<String, dynamic> toMap({bool selectedOnly = false}) => {
    'GROUP_CODE': groupCode,
    'GROUP_DETAIL': {
      'GROUP_CODE': groupCode,
      'GROUP_NAME': groupName,
      'STATUS': status,
      'IS_REQUIRED': isRequired,
      'TYPE': isApplyPrice,
      'IS_MULTISELECT': isMultiselect,
      'OPT_CHOICES': optChoices?.where((c) => !selectedOnly || c.isSelected == true).map((e) => e.toMap()).toList(),
    },
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MenuOption].
  factory MenuOption.fromJson(String data) {
    return MenuOption.fromMap(json.decode(data) as Map<String, dynamic>);
  }
  static List<MenuOption> fromListJson(List<dynamic> data) {
    return data.map((item) => MenuOption.fromMap(item as Map<String, dynamic>)).toList();
  }

  // from list json

  String toJson() => json.encode(toMap());

  MenuOption copyWith({
    String? groupCode,
    String? groupName,
    String? status,
    bool? isRequired,
    bool? isMultiselect,
    bool? isApplyPrice,
    bool? isSelected,
    List<OptChoice>? optChoices,
  }) {
    return MenuOption(
      groupCode: groupCode ?? this.groupCode,
      groupName: groupName ?? this.groupName,
      isApplyPrice: isApplyPrice ?? this.isApplyPrice,
      status: status ?? this.status,
      isRequired: isRequired ?? this.isRequired,
      isMultiselect: isMultiselect ?? this.isMultiselect,
      optChoices: optChoices ?? this.optChoices,
    );
  }
}
