import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/global_config.dart';
import 'package:mydictionaryapp/src/ui/screens/dictionary_screen/dictionary_screen.dart';
import 'package:mydictionaryapp/src/ui/widgets/environment_banner.dart';

//TODO: remove the imports
import 'package:mydictionaryapp/src/data/repositories/mocks/mock_user_repository.dart';
import 'package:mydictionaryapp/src/utils/localizations/localization.dart';

void runMyDictionaryApp() {
  runApp(MyDictionaryApp());
}

class MyDictionaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO: remove
    final dictionary = MockUserRepository().dictionary;

    return EnvironmentBanner(
      child: MaterialApp(
        title: appName,
        theme: GetIt.I.get<GlobalConfig>().theme,
        home: DictionaryScreen(dictionary: dictionary),
      ),
    );
  }
}
