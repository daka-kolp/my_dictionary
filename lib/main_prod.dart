import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/main.dart';
import 'package:mydictionaryapp/src/device/utils/global_config.dart';

void main() {
  GetIt.I.registerSingleton<GlobalConfig>(
    GlobalConfig(
      environment: Environment.prod,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.yellowAccent,
        cursorColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    ),
  );

  runMyDictionaryApp();
}
