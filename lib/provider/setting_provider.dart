import 'package:flutter/cupertino.dart';
import 'package:pos_ios_bvhn/model/user/user_model.dart';

class SettingProvider with ChangeNotifier {

  UserModel _userInfo;

  UserModel get userInfo => _userInfo;

  void setUserInfo(UserModel userModel) {
    _userInfo = userModel;
    notifyListeners();
  }
}
