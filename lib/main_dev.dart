import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/main.dart';
import 'package:mydictionaryapp/src/app/theme/my_dictionary_theme.dart';
import 'package:mydictionaryapp/src/data/repositories/mocks/mock_auth_repository.dart';
import 'package:mydictionaryapp/src/data/repositories/mocks/mock_dictionary_repository.dart';
import 'package:mydictionaryapp/src/data/repositories/mocks/mock_user_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final theme = MyDictionaryTheme.dev().theme;

  GetIt.I
    ..registerSingleton<ThemeData>(theme)
    ..registerSingleton<GlobalConfig>(
      GlobalConfig(
        environment: Environment.dev,
        mainImagePath: 'assets/images/icon_dev.png',
      ),
    )
    ..registerSingleton<AuthRepository>(MockAuthRepository())
    ..registerSingleton<UserRepository>(MockUserRepository())
    ..registerSingleton<DictionaryRepository>(MockDictionaryRepository());

  await runMyDictionaryApp();
}
