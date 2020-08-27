import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:mydictionaryapp/src/global_config.dart';
import 'package:mydictionaryapp/src/app/screens/auth_screens/login_screen_presenter.dart';
import 'package:mydictionaryapp/src/app/screens/words_screen/words_screen.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_layout.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/app/localization/localization.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        key: _scaffoldKey,
        body: Container(
          alignment: Alignment.center,
          decoration: _decoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Image.asset(GetIt.I<GlobalConfig>().mainImagePath),
              ),
              Expanded(
                child: Center(
                  child: RaisedButton(
                    child: Text(enterWithGoogle),
                    onPressed: _loginWithGoogle,
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginWithGoogle() async {
    try {
      await _read.loginWithGoogle();
      await _routeToDictionariesScreen();
    } catch (e) {
      //TODO: handle errors
      _showErrorMessage('LoginScreen: _loginWithGoogle() => $e');
    }
  }

  Future<void> _routeToDictionariesScreen() async {
    await Navigator.of(context).pushAndRemoveUntil(
      WordsScreen.buildPageRoute(),
      (route) => false,
    );
  }

  void _showErrorMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
