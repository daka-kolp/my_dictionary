import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';
import 'package:mydictionaryapp/src/ui/screens/dictionaries_screen/dictionaries_screen.dart';
import 'package:mydictionaryapp/src/ui/screens/login_screen/login_screen.dart';
import 'package:mydictionaryapp/src/ui/widgets/environment_banner.dart';

//TODO: remove the imports
import 'package:mydictionaryapp/src/utils/localization/localization.dart';

Future<void> runMyDictionaryApp() async {
  final isLoggedIn = await GetIt.I<AuthRepository>().isLoggedIn;
  runApp(MyDictionaryApp(isLoggedIn: isLoggedIn));
}

class MyDictionaryApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyDictionaryApp({
    Key key,
    @required this.isLoggedIn,
  })  : assert(isLoggedIn != null),
        super(key: key);

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
    if (isLoggedIn) {
      return DictionariesScreen.buildPageRoute();
    }
    return LoginScreen.buildPageRoute();
  }
}
