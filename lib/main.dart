import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/my_dictionary_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import 'package:mydictionaryapp/src/app/screens/auth_screens/login_page.dart';
import 'package:mydictionaryapp/src/app/screens/dictionaries_screen/dictionaries_page.dart';
import 'package:mydictionaryapp/src/app/widgets/environment_banner.dart';
import 'package:mydictionaryapp/src/device/utils/store_interator.dart';
import 'package:mydictionaryapp/src/domain/entities/user.dart';

Future<void> runMyDictionaryApp() async {
  GetIt.I
    ..registerSingleton<StoreInteractor>(StoreInteractor())
    ..registerSingleton<Uuid>(Uuid());
  final isLoggedIn = await User.I.isLoggedIn;

  runApp(MyDictionaryApp(isLoggedIn: isLoggedIn));
}

class MyDictionaryApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyDictionaryApp({
    Key? key,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnvironmentBanner(
      child: MaterialApp(
        theme: GetIt.I<ThemeData>(),
        onGenerateTitle: _onGenerateTitle,
        onGenerateRoute: (settings) => _onGenerateRoute(context, settings),
        localizationsDelegates: MyDictionaryLocalizations.localizationsDelegates,
        supportedLocales: MyDictionaryLocalizations.supportedLocales,
      ),
    );
  }

  String _onGenerateTitle(BuildContext context) {
    return MyDictionaryLocalizations.of(context)!.appName;
  }

  Route _onGenerateRoute(BuildContext context, RouteSettings settings) {
    if (isLoggedIn) {
      return DictionariesPage().createRoute(context);
    }
    return LoginPage().createRoute(context);
  }
}
