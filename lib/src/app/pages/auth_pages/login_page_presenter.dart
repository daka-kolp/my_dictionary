import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/user.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class LoginPagePresenter extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String get logo => GetIt.I<GlobalConfig>().mainImagePath;

  LoginPagePresenter();

  Future<void> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      await User.I.loginWithGoogle();
    } catch (e) {
      print('LoginScreenPresenter: loginWithGoogle() => $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
