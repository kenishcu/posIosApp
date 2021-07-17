import 'package:get/get.dart';
import 'package:pos_ios_bvhn/ui/login/login_screen.dart';

class NavigatorCustom {

  void toLogin() {
    Get.to(() => LoginScreen());
  }
}
