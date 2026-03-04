import 'dart:convert';
import 'dart:developer';

import 'package:pos_menu/model/user/user_model.dart';

class AllUserModel {
  List<UserModel>? users;
  bool? hasNext;

  AllUserModel({this.users, this.hasNext});

  AllUserModel copyWith({List<UserModel>? users, bool? hasNext}) {
    return AllUserModel(users: users ?? this.users, hasNext: hasNext ?? this.hasNext);
  }

  Map<String, dynamic> toMap() {
    return {'USERS': users != null ? jsonEncode(users!.map((e) => e.toJson())) : null, 'HAS_NEXT': hasNext};
  }

  factory AllUserModel.fromMap(Map<String, dynamic> map) {
    return AllUserModel(users: map['USERS'] != null ? UserModel().fromJsonArray(map['USERS']).toList() : null, hasNext: map['HAS_NEXT'] as bool);
  }
}
