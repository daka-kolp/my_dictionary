import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import 'package:mydictionaryapp/src/app/screens/dictionaries_screen/dictionaries_screen.dart';
import 'package:mydictionaryapp/src/app/screens/auth_screens/login_screen.dart';
import 'package:mydictionaryapp/src/app/widgets/environment_banner.dart';
import 'package:mydictionaryapp/src/domain/entities/user.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/device/utils/localization.dart';

Future<void> runMyDictionaryApp() async {
  GetIt.I.registerSingleton<Uuid>(Uuid());
  final isLoggedIn = await User.I.isLoggedIn;
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
