import 'package:pos_menu/model/permission/permission.dart';

class UserModel {
  int? userId;
  String? userCode; // Change from String? to int?
  String? dbCode;
  String? dbName;
  String? userName;
  String? userDesc;
  String? firstName;
  String? lastName;
  dynamic address;
  dynamic phone;
  dynamic email;
  dynamic map;
  String? userStatus; // Change from String? to int?
  String? userType;
  String? userLog;
  int? userCpas;
  int? approved;
  String? approvedBy; // Change from String? to int?
  dynamic empCode;
  dynamic userPeriod;
  dynamic field0;
  String? field1;
  dynamic field2;
  String? field3;
  dynamic field4;
  dynamic field5;
  dynamic field6;
  dynamic field7;
  dynamic field8;
  dynamic field9;
  dynamic userCreated;
  String? userCredate;
  dynamic userUpdt;
  dynamic dateUpdt;
  dynamic departmentId;
  String? roleType;
  dynamic deviceToken;
  Map<String, dynamic>? presets;
  String? profileImage;
  String? storeName;
  String? storeAddress;
  String? storeLatLng;
  String? planStatus;
  String? planName;
  String? planDuration;
  String? planCode;
  num? planRemainDay;
  List<PermissionEntity>? permissions;

  String? shopImagePath;

  bool? isSeleted;

  UserModel({
    this.isSeleted = false,
    this.userId,
    this.dbCode,
    this.dbName,
    this.userCode,
    this.userName,
    this.userDesc,
    this.firstName,
    this.lastName,
    this.address,
    this.phone,
    this.email,
    this.map,
    this.userStatus,
    this.userType,
    this.userLog,
    this.userCpas,
    this.approved,
    this.approvedBy,
    this.empCode,
    this.userPeriod,
    this.field0,
    this.field1,
    this.field2,
    this.field3,
    this.field4,
    this.field5,
    this.field6,
    this.field7,
    this.field8,
    this.field9,
    this.userCreated,
    this.userCredate,
    this.userUpdt,
    this.dateUpdt,
    this.departmentId,
    this.roleType,
    this.deviceToken,
    this.presets,
    this.profileImage,
    this.storeName,
    this.storeAddress,
    this.storeLatLng,
    this.planStatus,
    this.planName,
    this.planDuration,
    this.planCode,
    this.planRemainDay,
    this.permissions,
    this.shopImagePath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json['USER_ID'] as int?,
    dbCode: json['DB_CODE'] as String?,
    dbName: json['DB_NAME'] as String?,
    userCode: json['USER_CODE'] as String?, // Adjusted to int?
    userName: json['USER_NAME'] as String?,
    userDesc: json['USER_DESC'] as String?,
    firstName: json['FIRST_NAME'] as String?,
    lastName: json['LAST_NAME'] as String?,
    address: json['ADDRESS'] as dynamic,
    phone: json['PHONE'] as dynamic,
    email: json['EMAIL'] as dynamic,
    map: json['MAP'] as dynamic,
    userStatus: json['USER_STATUS'] as String?, // Adjusted to int?
    userType: json['USER_TYPE'] as String?,
    userLog: json['USER_LOG'] as String?,
    userCpas: json['USER_CPAS'] as int?,
    approved: json['APPROVED'] as int?,
    approvedBy: json['APPROVED_BY'] as String?, // Adjusted to int?
    empCode: json['EMP_CODE'] as dynamic,
    userPeriod: json['USER_PERIOD'] as dynamic,
    field0: json['FIELD_0'] as dynamic,
    field1: json['FIELD_1'] as String?,
    field2: json['FIELD_2'] as dynamic,
    field3: json['FIELD_3'] as String?,
    field4: json['FIELD_4'] as dynamic,
    field5: json['FIELD_5'] as dynamic,
    field6: json['FIELD_6'] as dynamic,
    field7: json['FIELD_7'] as dynamic,
    field8: json['FIELD_8'] as dynamic,
    field9: json['FIELD_9'] as dynamic,
    userCreated: json['USER_CREATED'] as dynamic,
    userCredate: json['USER_CREDATE'] as String?,
    userUpdt: json['USER_UPDT'] as dynamic,
    dateUpdt: json['DATE_UPDT'] as dynamic,
    departmentId: json['DEPARTMENT_ID'] as dynamic,
    roleType: json['ROLE_TYPE'] as String?,
    deviceToken: json['DEVICE_TOKEN'] as dynamic,
    presets: json['PRESETS'] as Map<String, dynamic>?,
    profileImage: json['profile_image'] as String?,
    storeAddress: json["STORE_ADDRESS"] as String?,
    storeName: json["STORE_NAME"] as String?,
    storeLatLng: json["STORE_MAP"] as String?,
    planStatus: json["PLAN_STATUS"] as String?,
    planName: json["PLAN_NAME"] as String?,
    planDuration: json["PLAN_DURATION"] as String?,
    planCode: json["PLAN_CODE"] as String?,
    planRemainDay: json["PLAN_REMAINDAY"] as num?,
    permissions: json["PERMISSIONS"] != null ? PermissionEntity().fromJsonArray(json["PERMISSIONS"]) : null,
    shopImagePath: json['SHOP_IMAGE_PATH'] as String?,
  );

  // to string method
  @override
  String toString() =>
      'UserModel(userId: $userId, userCode: $userCode, userName: $userName, userDesc: $userDesc, firstName: $firstName, lastName: $lastName, address: $address, phone: $phone, email: $email, map: $map, userStatus: $userStatus, userType: $userType, userLog: $userLog, userCpas: $userCpas, approved: $approved, approvedBy: $approvedBy, empCode: $empCode, userPeriod: $userPeriod, field0: $field0, field1: $field1, field2: $field2, field3: $field3, field4: $field4, field5: $field5, field6: $field6, field7: $field7, field8: $field8, field9: $field9, userCreated: $userCreated, userCredate: $userCredate, userUpdt: $userUpdt, dateUpdt: $dateUpdt, departmentId: $departmentId, roleType: $roleType, deviceToken: $deviceToken, presets: $presets, profileImage: $profileImage)';

  Map<String, dynamic> toJson() => {
    'USER_ID': userId,
    'USER_CODE': userCode,
    'USER_NAME': userName,
    'USER_DESC': userDesc,
    'FIRST_NAME': firstName,
    'LAST_NAME': lastName,
    'ADDRESS': address,
    'PHONE': phone,
    'EMAIL': email,
    'MAP': map,
    'USER_STATUS': userStatus,
    'USER_TYPE': userType,
    'USER_LOG': userLog,
    'USER_CPAS': userCpas,
    'APPROVED': approved,
    'APPROVED_BY': approvedBy,
    'EMP_CODE': empCode,
    'USER_PERIOD': userPeriod,
    'FIELD_0': field0,
    'FIELD_1': field1,
    'FIELD_2': field2,
    'FIELD_3': field3,
    'FIELD_4': field4,
    'FIELD_5': field5,
    'FIELD_6': field6,
    'FIELD_7': field7,
    'FIELD_8': field8,
    'FIELD_9': field9,
    'USER_CREATED': userCreated,
    'USER_CREDATE': userCredate,
    'USER_UPDT': userUpdt,
    'DATE_UPDT': dateUpdt,
    'DEPARTMENT_ID': departmentId,
    'ROLE_TYPE': roleType,
    'DEVICE_TOKEN': deviceToken,
    'PRESETS': presets,
    'profile_image': profileImage,
    'STORE_ADDRESS': storeAddress,
    'STORE_NAME': storeName,
    'STORE_MAP': storeLatLng,
  };

  // create a copyWith function
  UserModel copyWith({
    int? userId,
    String? dbCode,
    String? userCode, // Change from String? to int?
    String? userName,
    String? userDesc,
    String? firstName,
    String? lastName,
    dynamic address,
    dynamic phone,
    dynamic email,
    dynamic map,
    String? userStatus, // Change from String? to int?
    String? userType,
    String? userLog,
    int? userCpas,
    int? approved,
    String? approvedBy, // Change from String? to int?
    dynamic empCode,
    dynamic userPeriod,
    dynamic field0,
    String? field1,
    dynamic field2,
    String? field3,
    dynamic field4,
    dynamic field5,
    dynamic field6,
    dynamic field7,
    dynamic field8,
    dynamic field9,
    dynamic userCreated,
    String? userCredate,
    dynamic userUpdt,
    dynamic dateUpdt,
    dynamic departmentId,
    String? roleType,
    dynamic deviceToken,
    Map<String, dynamic>? presets,
    String? profileImage,
    String? storeName,
    String? storeAddress,
    String? storeLatLng,
    String? planStatus,
    String? planName,
    String? planDuration,
    String? planCode,
    num? planRemainDay,
    List<PermissionEntity>? permissions,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userCode: userCode ?? this.userCode,
      userName: userName ?? this.userName,
      userDesc: userDesc ?? this.userDesc,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      map: map ?? this.map,
      userStatus: userStatus ?? this.userStatus,
      userType: userType ?? this.userType,
      userLog: userLog ?? this.userLog,
      userCpas: userCpas ?? this.userCpas,
      approved: approved ?? this.approved,
      approvedBy: approvedBy ?? this.approvedBy,
      empCode: empCode ?? this.empCode,
      userPeriod: userPeriod ?? this.userPeriod,
      field0: field0 ?? this.field0,
      field1: field1 ?? this.field1,
      field2: field2 ?? this.field2,
      field3: field3 ?? this.field3,
      field4: field4 ?? this.field4,
      field5: field5 ?? this.field5,
      field6: field6 ?? this.field6,
      field7: field7 ?? this.field7,
      field8: field8 ?? this.field8,
      field9: field9 ?? this.field9,
      userCreated: userCreated ?? this.userCreated,
      userCredate: userCredate ?? this.userCredate,
      userUpdt: userUpdt ?? this.userUpdt,
      dateUpdt: dateUpdt ?? this.dateUpdt,
      departmentId: departmentId ?? this.departmentId,
      roleType: roleType ?? this.roleType,
      deviceToken: deviceToken ?? this.deviceToken,
      presets: presets ?? this.presets,
      profileImage: profileImage ?? this.profileImage,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      storeLatLng: storeLatLng ?? this.storeLatLng,
      planStatus: planStatus ?? this.planStatus,
      planName: planName ?? this.planName,
      planDuration: planDuration ?? this.planDuration,
      planCode: planCode ?? this.planCode,
      planRemainDay: planRemainDay ?? this.planRemainDay,
      permissions: permissions ?? this.permissions,
    );
  }

  List<UserModel> fromJsonArray(List json) => json.map((e) => UserModel.fromJson(e)).toList();
}
