import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';

class EditWordScreenPresenter extends ChangeNotifier {
  final Dictionary dictionary;
  final Word _word;
  final DictionaryRepository _dictionaryRepository;

  bool _isLoading = false;

  Word get word => _word;
  bool get isLoading => _isLoading;

  EditWordScreenPresenter(this.dictionary, Word word)
      : _word = word,
        _dictionaryRepository = GetIt.I.get<DictionaryRepository>(
          instanceName: dictionary.id,
        );

  Future<void> editWord(Word word) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _dictionaryRepository.editWord(word);
    } catch (e) {
      print('EditWordScreenPresenter: editWord(word) => $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeWord() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _dictionaryRepository.removeWord(word.id);
    } catch (e) {
      print('EditWordScreenPresenter: removeWord() => $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
