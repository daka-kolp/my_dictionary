import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class WordsScreenPresenter with ChangeNotifier {
  final Dictionary dictionary;
  final _fetchedStep = GetIt.I<GlobalConfig>().fetchStep;

  List<Word> _words;
  bool _isNewWordsAvailable = true;
  bool _isNewWordsLoading = false;
  bool _isWordListUpdating = false;
  int _firstIndex = 0;

  List<Word> get words => _words;
  bool get isNewWordsLoading => _isNewWordsLoading;
  bool get isLoading => _isWordListUpdating;

  WordsScreenPresenter(this.dictionary) {
    _init();
  }

  Future<void> _init() async {
    _isNewWordsLoading = true;
    notifyListeners();
    try {
      try {
        _words = await dictionary.getWords(_firstIndex, _fetchedStep);
        if (_words.length < _fetchedStep) {
          _isNewWordsAvailable = false;
        }
        _firstIndex += _fetchedStep;
      } catch (e) {
        print('WordsScreenPresenter: _init() => inner "try" : $e');
        rethrow;
      } finally {
        _isNewWordsLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print('WordsScreenPresenter: _init() => outer "try" : $e');
    }
  }

  Future<void> uploadNewWords() async {
    if (_isNewWordsLoading) return;
    if (_isNewWordsAvailable) {
      _isNewWordsLoading = true;
      notifyListeners();

      try {
        final newWords = await dictionary.getWords(
          _firstIndex,
          _fetchedStep,
        );

        if (newWords.length < _fetchedStep) {
          _isNewWordsAvailable = false;
        }
        _words += newWords;
        _firstIndex += _fetchedStep;
      } catch (e) {
        print('WordsScreenPresenter: uploadNewWords() => $e');
        rethrow;
      } finally {
        _isNewWordsLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> addNewWord(Word newWord) async {
    _isWordListUpdating = true;
    notifyListeners();
    try {
      await dictionary.addWord(newWord);
      words.insert(0, newWord);
    } catch (e) {
      print('NewWordScreenPresenter: addNewWord(newWord) => $e');
      rethrow;
    } finally {
      _isWordListUpdating = false;
      notifyListeners();
    }
  }

  Future<void> updateWord(Word editedWord) async {
    _isWordListUpdating = true;
    notifyListeners();
    try {
      await dictionary.editWord(editedWord);
      int wordIndex = _words.indexWhere((w) => w.id == editedWord.id);
      _words
        ..removeAt(wordIndex)
        ..insert(wordIndex, editedWord);
    } catch (e) {
      print('EditWordScreenPresenter: editWord(editedWord) => $e');
      rethrow;
    } finally {
      _isWordListUpdating = false;
      notifyListeners();
    }
  }

  Future<void> removeWord(String removedWordId) async {
    _isWordListUpdating = true;
    notifyListeners();
    try {
      await dictionary.removeWord(removedWordId);
      _words.removeWhere((w) => w.id == removedWordId);
    } catch (e) {
      print('EditWordScreenPresenter: removeWord(removedWordId) => $e');
      rethrow;
    } finally {
      _isWordListUpdating = false;
      notifyListeners();
    }
  }
}
