import 'package:flutter/material.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';
import 'package:pos_ios_bvhn/model/user/user_model.dart';
import 'package:pos_ios_bvhn/provider/setting_provider.dart';
import 'package:pos_ios_bvhn/service/authen_service.dart';
import 'package:pos_ios_bvhn/sqflite/user_sqflite.dart';
import 'package:pos_ios_bvhn/ui/login/branch_selection_screen.dart';
import 'package:pos_ios_bvhn/ui/login/login_screen.dart';
import 'package:provider/provider.dart';

class DrawerCustom extends StatelessWidget {

  final authService = new AuthRepository();

  @override
  Widget build(BuildContext context) {

    UserModel userInfo  =  Provider.of<SettingProvider>(context, listen: false).userInfo;

    // TODO: implement build
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFF0e1e2b)
        ),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      child: Text("Tài khoản : ${userInfo.userName}", style: TextStyle(
                          color: Colors.white
                      )),
                    ),
                    Container(
                      height: 40,
                      child: Text("Quyền ${userInfo.roleName}, Chi nhánh ${userInfo.branchName}", style: TextStyle(
                          color: Color(0xFF848b92)
                      )),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFF0e1e2b)
              ),
              child: ListTile(
                leading: Icon(
                  Icons.repeat,
                  color: Colors.white,
                ),
                title: Text('Chọn chi nhánh', style: TextStyle(
                  color: Colors.white,
                )),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BranchSelectionScreen())
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFF0e1e2b)
              ),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text('Đăng xuất', style: TextStyle(
                  color: Colors.white,
                )),
                onTap: () async {
                  ResultModel res = await authService.logout();
                  if(res.status) {
                    // clear cache
                    UserSqfLite userSqfLite = new UserSqfLite();
                    await userSqfLite.delete(1);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen())
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
