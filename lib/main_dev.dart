import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/main.dart';
import 'package:mydictionaryapp/src/data/repositories/mocks/mock_auth_repository.dart';
import 'package:mydictionaryapp/src/data/repositories/mocks/mock_dictionary_repository.dart';
import 'package:mydictionaryapp/src/data/repositories/mocks/mock_user_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';
import 'package:mydictionaryapp/src/device/utils/store_interator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final theme = ThemeData(
    primarySwatch: Colors.green,
    accentColor: Colors.redAccent,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.redAccent[100],
        onPrimary: Colors.black,
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),
    ),
  );

  GetIt.I
    ..registerSingleton<ThemeData>(theme)
    ..registerSingleton<GlobalConfig>(
      GlobalConfig(
        environment: Environment.dev,
        mainImagePath: 'assets/images/icon_dev.png',
      ),
    )
    ..registerSingleton<StoreInteractor>(StoreInteractor())
    ..registerSingleton<AuthRepository>(MockAuthRepository())
    ..registerSingleton<UserRepository>(MockUserRepository())
    ..registerSingleton<DictionaryRepository>(MockDictionaryRepository());

  await runMyDictionaryApp();
}
