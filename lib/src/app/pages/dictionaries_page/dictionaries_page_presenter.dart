import 'package:flutter/widgets.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/user.dart';

class DictionariesPagePresenter with ChangeNotifier {
  late List<Dictionary> _dictionaries;
  bool _isInit = true;
  bool _isDictionariesLoading = false;
  bool _isLoading = false;
  bool _isDictionariesListUpdating = false;

  User get _user => User.I;
  List<Dictionary> get dictionaries => List.unmodifiable(_dictionaries);
  bool get isDictionariesLoading => _isDictionariesLoading;
  bool get isInit => _isInit;
  bool get isLoading => _isLoading || _isDictionariesListUpdating;

  DictionariesPagePresenter() {
    _init();
  }

  Future<void> _init() async {
    _isDictionariesLoading = true;
    notifyListeners();
    try {
      _dictionaries = await _user.getDictionaries();
    } catch (e) {
      _dictionaries = <Dictionary>[];
    } finally {
      _isDictionariesLoading = false;
      _isInit = false;
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
      print('DictionariesScreenPresenter: changeUser() => $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createDictionary(Dictionary newDictionary) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _user.createDictionary(newDictionary);
      _dictionaries.insert(0, newDictionary);
    } catch (e) {
      print('DictionariesScreenPresenter: createDictionary(newDictionary) => $e');
      rethrow;
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
      final dictionaryIndex =
          _dictionaries.indexWhere((w) => w.id == editedDictionary.id);
      _dictionaries
        ..removeAt(dictionaryIndex)
        ..insert(dictionaryIndex, editedDictionary);
    } catch (e) {
      print('DictionariesScreenPresenter: editDictionary(editedWord) => $e');
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
      _dictionaries.removeWhere((w) => w.id == removedDictionaryId);
    } catch (e) {
      print('DictionariesScreenPresenter: removeDictionary(removedDictionaryId) => $e');
      rethrow;
    } finally {
      _isDictionariesListUpdating = false;
      notifyListeners();
    }
  }
}
