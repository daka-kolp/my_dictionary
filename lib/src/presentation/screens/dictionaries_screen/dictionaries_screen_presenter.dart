import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class DictionariesScreenPresenter with ChangeNotifier {
  final _userRepository = GetIt.I<UserRepository>();
  final _authRepository = GetIt.I<AuthRepository>();
  final _fetchStep = GetIt.I<GlobalConfig>().fetchStep;

  List<Dictionary> _dictionaries;
  bool _isNewDictionariesAvailable = true;
  bool _isNewDictionariesLoading = false;
  bool _isLoading = false;

  List<Dictionary> get dictionaries => _dictionaries;
  bool get isNewDictionariesLoading => _isNewDictionariesLoading;
  bool get isLoading => _isLoading;

  DictionariesScreenPresenter() {
    _init();
  }

  Future<void> _init() async {
    _isNewDictionariesLoading = true;
    notifyListeners();
    try {
      _dictionaries =
          await _userRepository.getAndRegisterDictionaries(_fetchStep);
      if (_dictionaries.length < _fetchStep) {
        _isNewDictionariesAvailable = false;
        notifyListeners();
      }
    } catch (e) {
      print('DictionariesScreenPresenter: _init() => $e');
      rethrow;
    } finally {
      _isNewDictionariesLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadNewDictionaries() async {
    if (_isNewDictionariesLoading) return;
    if (_isNewDictionariesAvailable) {
      _isNewDictionariesLoading = true;
      notifyListeners();

      try {
        final newDictionaries =
            await _userRepository.getAndRegisterDictionaries(_fetchStep);

        if (newDictionaries.length < _fetchStep) {
          _isNewDictionariesAvailable = false;
          notifyListeners();
        }
        _dictionaries += newDictionaries;
      } catch (e) {
        print('DictionariesScreenPresenter: uploadNewDictionaries() => $e');
        rethrow;
      } finally {
        _isNewDictionariesLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> changeUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      bool isLoggedOut = await _authRepository.logOut();
      if (!isLoggedOut) {
        throw LogOutException();
      }
    } catch (e) {
      print('DictionariesScreenPresenter: changeUser() => $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _userRepository.unregisterDictionaries(_dictionaries);
    super.dispose();
  }
}
