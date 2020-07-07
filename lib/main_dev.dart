import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/main.dart';
import 'package:mydictionaryapp/src/device/utils/global_config.dart';

void main() {
  GetIt.I.registerSingleton<GlobalConfig>(
    GlobalConfig(
      environment: Environment.dev,
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.redAccent,
        cursorColor: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.redAccent[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        ),
      ),
    ),
  );

  runMyDictionaryApp();
}
