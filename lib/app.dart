import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_ios_bvhn/provider/setting_provider.dart';
import 'package:pos_ios_bvhn/sqflite/model/user_model_sqflite.dart';
import 'package:pos_ios_bvhn/sqflite/user_sqflite.dart';
import 'package:pos_ios_bvhn/ui/home/home_screen.dart';
import 'package:pos_ios_bvhn/ui/home/table_screen.dart';
import 'package:pos_ios_bvhn/ui/login/branch_selection_screen.dart';
import 'package:pos_ios_bvhn/ui/login/login_screen.dart';
import 'package:pos_ios_bvhn/ui/order/order_screen.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  int cnt = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStateInit();
  }

  Future checkStateInit() async {
    UserSqfLite userSqfLite = new UserSqfLite();
    int c = await userSqfLite.queryRowCount();
    setState(() {
      cnt = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Consumer<SettingProvider>(
        builder: (context, setting, child) => MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => cnt > 0 ? TableScreen() : LoginScreen()
          },
        ),
      ),
    );
  }

}
