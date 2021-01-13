import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/main.dart';
import 'package:mydictionaryapp/src/data/repositories/firebase/firebase_auth_repository.dart';
import 'package:mydictionaryapp/src/data/repositories/firebase/firebase_dictionary_repository.dart';
import 'package:mydictionaryapp/src/data/repositories/firebase/firebase_user_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';
import 'package:mydictionaryapp/src/data/utils/store_interator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final theme = ThemeData(
    primarySwatch: Colors.blue,
    accentColor: Colors.yellowAccent,
    cursorColor: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.yellowAccent[700],
      padding: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
    ),
  );

  GetIt.I
    ..registerSingleton<ThemeData>(theme)
    ..registerSingleton<GlobalConfig>(
      GlobalConfig(
        environment: Environment.prod,
        mainImagePath: 'assets/images/icon_prod.png',
      ),
    )
    ..registerSingleton<StoreInteractor>(StoreInteractor())
    ..registerSingleton<AuthRepository>(FirebaseAuthRepository())
    ..registerSingleton<UserRepository>(FirebaseUserRepository())
    ..registerSingleton<DictionaryRepository>(FirebaseDictionaryRepository());

  runMyDictionaryApp();
}
