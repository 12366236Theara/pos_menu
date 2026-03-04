class UserCacheModel {
  String? username;
  String? password;
  String? dbSelected;
  String? accessToken;
  String? presetId;

  UserCacheModel({this.username, this.password, this.dbSelected, this.accessToken, this.presetId});

  UserCacheModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    dbSelected = json['dbselected'];
    accessToken = json['accessToken'];
    presetId = json['presetId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['dbselected'] = dbSelected;
    data['accessToken'] = accessToken;
    data['presetId'] = presetId;
    return data;
  }
}
