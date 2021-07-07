import 'package:flutter/widgets.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/entities/user.dart';

class NewDictionaryPagePresenter with ChangeNotifier {
  User get _user => User.I;

  bool _isLoading = false;
  bool _isLanguagesLoading = false;
  List<Language> _languages = [];

  bool get isLoading => _isLoading;
  bool get isLanguagesLoading => _isLanguagesLoading;
  List<Language> get languages => List.unmodifiable(_languages);

  NewDictionaryPagePresenter() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = _isLanguagesLoading = true;
    notifyListeners();
    _languages = await _user.languages;
    _isLoading = _isLanguagesLoading = false;
    notifyListeners();
  }

  Future<void> createDictionary(Dictionary newDictionary) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _user.createDictionary(newDictionary);
    } catch (e) {
      print('NewDictionaryPagePresenter: createDictionary(newDictionary) => $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
