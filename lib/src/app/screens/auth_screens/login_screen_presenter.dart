import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';

class LoginScreenPresenter extends ChangeNotifier {
  final AuthRepository _authRepository;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  LoginScreenPresenter() : _authRepository = GetIt.I<AuthRepository>();

  Future<void> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.loginWith(GOOGLE);
    } catch (e) {
      print('LoginScreenPresenter: loginWithGoogle() => $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
