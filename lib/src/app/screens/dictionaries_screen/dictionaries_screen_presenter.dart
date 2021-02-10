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
  bool _isDictionariesListUpdating = false;
  int _firstIndex = 0;

  User get _user => User.I;
  List<Dictionary> get dictionaries => _dictionaries;
  bool get isNewDictionariesLoading => _isNewDictionariesLoading;
  bool get isLoading => _isLoading || _isDictionariesListUpdating;

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
      _dictionaries = <Dictionary>[];
      print('DictionariesScreenPresenter: _init() => $e');
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
        final newDictionaries = await _user.getDictionaries(
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
