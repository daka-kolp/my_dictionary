import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mydictionaryapp/src/app/screens/dictionaries_screen/dictionaries_screen.dart';
import 'package:mydictionaryapp/src/app/screens/auth_screens/login_screen_presenter.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/app/utils/show_snack_bar.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/device/utils/localization.dart';

class LoginScreen extends StatefulWidget {
  static PageRoute buildPageRoute() {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder);
    }
    return MaterialPageRoute(builder: _builder);
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginScreenPresenter(),
      child: LoginScreen(),
    );
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
  LoginScreenPresenter get _watch => context.watch<LoginScreenPresenter>();
  LoginScreenPresenter get _read => context.read<LoginScreenPresenter>();

  @override
  Widget build(BuildContext context) {
    return LoadingLayout(
      isLoading: _watch.isLoading,
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: _decoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(child: Image.asset(_watch.logo)),
              Expanded(child: _buildLoginButtons()),
              Expanded(child: SizedBox())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButtons() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            child: Text(enterWithGoogle),
            onPressed: _loginWithGoogle,
          ),
          if (Platform.isIOS)
            Column(
              children: [
                SizedBox(height: 16.0),
                Text(or),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: Text(enterWithApple),
                  onPressed: _loginWithApple,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _loginWithGoogle() async {
    try {
      await _read.loginWithGoogle();
      await _routeToDictionariesScreen();
    } on WrongCredentialsException {
      showErrorMessage(context, wrongCredentials);
    } catch (e) {
      //TODO: handle errors
      showErrorMessage(context, e.toString());
    }
  }

  Future<void> _loginWithApple() async {
    //TODO: implement _loginWithApple
  }

  Future<void> _routeToDictionariesScreen() async {
    await Navigator.of(context).pushAndRemoveUntil(
      DictionariesScreen.buildPageRoute(),
      (route) => false,
    );
  }
}
