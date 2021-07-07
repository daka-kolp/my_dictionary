import 'package:flutter/widgets.dart';

import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/entities/user.dart';

class NewDictionaryPagePresenter with ChangeNotifier {
  User get _user => User.I;

  bool _isLoading = false;
  List<Language> _languages = [];

  bool get isLoading => _isLoading;
  List<Language> get languages => List.unmodifiable(_languages);

  NewDictionaryPagePresenter() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    _languages = await _user.languages;
    _isLoading = false;
    notifyListeners();
  }
}
