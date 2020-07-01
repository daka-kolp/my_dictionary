import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/ui/widgets/environment_banner.dart';

void runMyDictionaryApp() {
  runApp(MyDictionaryApp());
}

class MyDictionaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EnvironmentBanner(
      child: MaterialApp(
        title: 'MyDictionary',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(),
      ),
    );
  }
}
