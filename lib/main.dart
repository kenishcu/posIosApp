import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_ios_bvhn/app.dart';
import 'package:pos_ios_bvhn/provider/setting_provider.dart';
import 'package:provider/provider.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  //Do this in main.dart
  SystemChrome.setPreferredOrientations([ DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight])
  .then((_) {
    runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SettingProvider()),
          ],
          child: App(),
        )
    );
  });
}

