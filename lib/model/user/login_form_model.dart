class LoginFormModel {
  String _userName;
  String _password;

  LoginFormModel(this._userName, this._password);

  factory LoginFormModel.fromJson(dynamic json) {
    return LoginFormModel(json['user_name'] as String, json['password'] as String);
  }

  toJson() {
    return {
      'user_name': _userName,
      'password': _password
    };
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }
  String get password => _password;

  set password(String value) {
    _password = value;
  }
}
