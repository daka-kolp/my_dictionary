import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/entities/user.dart';

class NewDictionaryScreenPresenter with ChangeNotifier {
  User get _user =>  User.I;

  List<Language> _languages = [];
  bool _isLoading = false;

  List<Language> get languages => _languages;
  bool get isLoading => _isLoading;

  NewDictionaryScreenPresenter() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    _languages = await _user.getLanguages();
    _isLoading = false;
    notifyListeners();
  }
}
