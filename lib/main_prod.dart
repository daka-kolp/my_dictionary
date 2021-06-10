import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/main.dart';
import 'package:mydictionaryapp/src/app/theme/my_dictionary_theme.dart';
import 'package:mydictionaryapp/src/data/repositories/firebase/firebase_auth_repository.dart';
import 'package:mydictionaryapp/src/data/repositories/firebase/firebase_dictionary_repository.dart';
import 'package:mydictionaryapp/src/data/repositories/firebase/firebase_user_repository.dart';
import 'package:mydictionaryapp/src/data/utils/dictionaries_service.dart';
import 'package:mydictionaryapp/src/data/utils/google_service.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final theme = MyDictionaryTheme.prod().theme;

  GetIt.I
    ..registerSingleton<ThemeData>(theme)
    ..registerSingleton<GlobalConfig>(
      GlobalConfig(
        environment: Environment.prod,
        mainImagePath: 'assets/images/icon_prod.png',
      ),
    )
    ..registerSingleton<GoogleService>(GoogleService())
    ..registerSingleton<DictionariesService>(DictionariesService())
    ..registerSingleton<AuthRepository>(FirebaseAuthRepository())
    ..registerSingleton<UserRepository>(FirebaseUserRepository())
    ..registerSingleton<DictionaryRepository>(FirebaseDictionaryRepository());

  await Firebase.initializeApp();
  await runMyDictionaryApp();
}
