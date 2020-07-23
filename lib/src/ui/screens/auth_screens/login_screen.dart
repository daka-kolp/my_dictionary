import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/global_config.dart';
import 'package:mydictionaryapp/src/ui/screens/dictionaries_screen/dictionaries_screen.dart';
import 'package:mydictionaryapp/src/ui/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/utils/localization/localization.dart';

class LoginScreen extends StatefulWidget {
  static PageRoute buildPageRoute() {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder);
    }
    return MaterialPageRoute(builder: _builder);
  }

  static Widget _builder(BuildContext context) {
    //TODO: add LoginScreenPresenter
    return LoginScreen();
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ThemeData get _theme => Theme.of(context);

  BoxDecoration get _decoration => BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _theme.accentColor.withOpacity(0.3),
            _theme.primaryColor.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return LoadingLayout(
      isLoading: false,
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: _decoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Image.asset(GetIt.I<GlobalConfig>().mainImagePath),
              ),
              RaisedButton(child: Text(enter), onPressed: _login),
              SizedBox(height: 16.0),
              Text(or),
              SizedBox(height: 16.0),
              RaisedButton(child: Text(register), onPressed: _register),
              Expanded(child: SizedBox())
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    //TODO: login
    Navigator.of(context).push(DictionariesScreen.buildPageRoute());
  }

  Future<void> _register() async {
    //TODO: registration
  }
}
