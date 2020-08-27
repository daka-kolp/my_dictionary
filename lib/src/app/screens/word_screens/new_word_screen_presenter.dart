import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';

class NewWordScreenPresenter extends ChangeNotifier {
  Dictionary get dictionary => _dictionaryRepository.dictionary;
  final DictionaryRepository _dictionaryRepository;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  NewWordScreenPresenter()
      : _dictionaryRepository = GetIt.I.get<DictionaryRepository>();

  Future<void> addWordToDictionary(Word word) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _dictionaryRepository.addNewWord(word);
    } catch (e) {
      print('NewWordScreenPresenter: addWordToDictionary(word) => $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
