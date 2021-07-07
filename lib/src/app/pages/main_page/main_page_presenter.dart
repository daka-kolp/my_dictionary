import 'package:flutter/widgets.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/user.dart';

class MainPagePresenter with ChangeNotifier {
  late UserData? _userData;
  late List<Dictionary> _dictionaries;
  bool _isInit = true;
  bool _isUserDataLoading = false;
  bool _isDictionariesLoading = false;
  bool _isLoading = false;
  bool _isDictionariesListUpdating = false;

  User get _user => User.I;
  UserData? get userData => _userData;
  List<Dictionary> get dictionaries => List.unmodifiable(_dictionaries);
  bool get isUserDataLoading => _isUserDataLoading;
  bool get isDictionariesLoading => _isDictionariesLoading;
  bool get isInit => _isInit;
  bool get isLoading => _isLoading || _isDictionariesListUpdating;

  MainPagePresenter() {
    _init();
  }

  Future<void> _init() async {
    _isUserDataLoading = _isDictionariesLoading = true;
    notifyListeners();
    _userData = await _user.userData;
    _isUserDataLoading = false;
    notifyListeners();
    try {
      _dictionaries = await _user.dictionaries;
    } catch (e) {
      _dictionaries = <Dictionary>[];
    } finally {
      _isDictionariesLoading = _isInit = false;
      notifyListeners();
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
      print('MainPagePresenter: changeUser() => $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editDictionary(Dictionary editedDictionary) async {
    _isDictionariesListUpdating = true;
    notifyListeners();
    try {
      await _user.editDictionary(editedDictionary);
      _dictionaries = await _user.dictionaries;
    } catch (e) {
      print('MainPagePresenter: editDictionary(editedWord) => $e');
      rethrow;
    } finally {
      _isDictionariesListUpdating = false;
      notifyListeners();
    }
  }

  Future<void> removeDictionary(String removedDictionaryId) async {
    _isDictionariesListUpdating = true;
    notifyListeners();
    try {
      await _user.removeDictionary(removedDictionaryId);
      _dictionaries = await _user.dictionaries;
    } catch (e) {
      print('MainPagePresenter: removeDictionary(removedDictionaryId) => $e');
      rethrow;
    } finally {
      _isDictionariesListUpdating = false;
      notifyListeners();
    }
  }
}