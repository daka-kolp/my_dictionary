import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/main.dart';
import 'package:mydictionaryapp/src/data/repositories/mocks/mock_auth_repository.dart';
import 'package:mydictionaryapp/src/data/repositories/mocks/mock_user_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';
import 'package:mydictionaryapp/src/utils/store_interator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final theme = ThemeData(
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
  );

  GetIt.I
    ..registerSingleton<ThemeData>(theme)
    ..registerSingleton<GlobalConfig>(
        GlobalConfig(environment: Environment.dev))
    ..registerSingleton<StoreInteractor>(StoreInteractor())
    ..registerSingleton<AuthRepository>(MockAuthRepository())
    ..registerSingleton<UserRepository>(MockUserRepository());

  runMyDictionaryApp();
}
