import 'package:flutter/widgets.dart';

import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/entities/user.dart';

class NewDictionaryScreenPresenter with ChangeNotifier {
  User get _user => User.I;

  bool _isLoading = false;
  List<Language> _languages = [];
  Language _platformLanguage;

  bool get isLoading => _isLoading;
  List<Language> get languages => _languages;
  Language get platformLanguage => _platformLanguage;

  NewDictionaryScreenPresenter() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    _languages = await _user.getLanguages();
    _platformLanguage = await _user.getLocalLanguage();
    _isLoading = false;
    notifyListeners();
  }
}
