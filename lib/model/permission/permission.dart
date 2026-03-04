class PermissionEntity {
  String? dbCode;
  String? userId;
  String? module;
  String? permission;
  bool? checked;

  PermissionEntity({this.dbCode, this.userId, this.module, this.permission, this.checked});

  @override
  String toString() {
    return 'PermissionEntity{ dbCode: $dbCode, userId: $userId, mainModule: $module, permission: $permission, checked: $checked,}';
  }

  PermissionEntity copyWith({String? dbCode, String? userId, String? module, String? permission, bool? checked}) {
    return PermissionEntity(
      dbCode: dbCode ?? dbCode,
      userId: userId ?? userId,
      module: module ?? module,
      permission: permission ?? permission,
      checked: checked ?? checked,
    );
  }

  Map<String, dynamic> toMap() {
    return {'DB_CODE': dbCode, 'USER_CODE': userId, 'GR_DB_CODE': module, 'PER_ACTION': permission, 'CHECKED': checked};
  }

  PermissionEntity.fromMap(Map<String, dynamic> map) {
    try {
      dbCode = map['DB_CODE'];
      userId = map['USER_CODE'];
      module = map['GR_DB_CODE'];
      permission = map['PER_ACTION'];
      checked = false;
    } catch (e) {
      print(e);
    }
  }

  List<PermissionEntity> fromJsonArray(List json) => json.map((e) => PermissionEntity.fromMap(e)).toList();
}
