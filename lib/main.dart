import 'package:flutter/material.dart';
import 'package:pos_ios_bvhn/app.dart';
import 'package:pos_ios_bvhn/provider/setting_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingProvider()),
      ],
      child: App(),
    )
  );
}

