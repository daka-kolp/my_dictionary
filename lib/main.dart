import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/ui/screens/dictionaries_screen/dictionaries_screen.dart';
import 'package:mydictionaryapp/src/ui/widgets/environment_banner.dart';

//TODO: remove the imports
import 'package:mydictionaryapp/src/utils/localization/localization.dart';

void runMyDictionaryApp() {
  runApp(MyDictionaryApp());
}

class MyDictionaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return EnvironmentBanner(
      child: MaterialApp(
        title: appName,
        theme: GetIt.I<ThemeData>(),
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    return DictionariesScreen.buildPageRoute();
  }
}
