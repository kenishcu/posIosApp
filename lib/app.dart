import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_ios_bvhn/provider/setting_provider.dart';
import 'package:pos_ios_bvhn/ui/home/table_screen.dart';
import 'package:pos_ios_bvhn/ui/login/branch_selection_screen.dart';
import 'package:pos_ios_bvhn/ui/login/login_screen.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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
            '/': (context) => LoginScreen()
          },
        ),
      ),
    );
  }

}
