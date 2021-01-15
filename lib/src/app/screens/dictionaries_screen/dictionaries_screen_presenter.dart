import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/user.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class DictionariesScreenPresenter with ChangeNotifier {
  final _fetchedStep = GetIt.I<GlobalConfig>().fetchStep;

  List<Dictionary> _dictionaries;
  bool _isNewDictionariesAvailable = true;
  bool _isNewDictionariesLoading = false;
  bool _isLoading = false;
  int _firstIndex = 0;

  User get _user =>  User.I;

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
      _dictionaries = await _user.getDictionaries(
        _firstIndex,
        _fetchedStep,
      );
      if (_dictionaries.length < _fetchedStep) {
        _isNewDictionariesAvailable = false;
      }
      _firstIndex += _fetchedStep;
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
        final newDictionaries =  await _user.getDictionaries(
          _firstIndex,
          _fetchedStep,
        );

        if (newDictionaries.length < _fetchedStep) {
          _isNewDictionariesAvailable = false;
        }
        _dictionaries += newDictionaries;
        _firstIndex += _fetchedStep;
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
      bool isLoggedOut = await _user.logOut();
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
}
