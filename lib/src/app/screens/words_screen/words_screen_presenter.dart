import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';
import 'package:mydictionaryapp/src/app/utils/dimens.dart';

class WordsScreenPresenter extends ChangeNotifier {
  final BuildContext context;
  final Dictionary dictionary;
  final DictionaryRepository _dictionaryRepository;
  final _fetchStep = GetIt.I<GlobalConfig>().fetchStep;

  List<Word> _words;
  int _offset = 0;
  bool _isNewWordsAvailable = true;
  bool _isNewWordsLoading = false;

  List<Word> get words => _words;
  bool get isNewWordsLoading => _isNewWordsLoading;
  bool get isLoading => _words == null;

  WordsScreenPresenter(
    this.context,
    this.dictionary,
  ) : _dictionaryRepository = GetIt.I.get<DictionaryRepository>(
          instanceName: dictionary.id,
        ) {
    _init();
  }

  Future<void> _init() async {
    try {
      try {
        _words = await _dictionaryRepository.getWords(_offset);
        if (_isScrollControllerNotActive) {
          await uploadNewWords();
        }
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
    if (_isNewWordsAvailable) {
      _isNewWordsLoading = true;
      notifyListeners();

      try {
        _offset += _fetchStep;
        final newWords = await _dictionaryRepository.getWords(_offset);

        if (newWords.isEmpty) {
          _isNewWordsAvailable = false;
        } else {
          _words += newWords;
        }
        if (_isScrollControllerNotActive) {
          await uploadNewWords();
        }
      } on RangeError catch (e) {
        print(e.message);
        _isNewWordsAvailable = false;
      } catch (e) {
        print('WordsScreenPresenter: uploadNewWords() => $e');
        rethrow;
      } finally {
        _isNewWordsLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> insertNewWord(Word newWord) async {
    words.insert(0, newWord);
    notifyListeners();
  }

  Future<void> updateWord(Word editedWord) async {
    int wordIndex = _words.indexWhere((w) => w.id == editedWord.id);
    _words
      ..removeAt(wordIndex)
      ..insert(wordIndex, editedWord);
    notifyListeners();
  }

  Future<void> removeWord(String removedWordId) async {
    Word word = _words.firstWhere((w) => w.id == removedWordId);
    print(word.word);
    _words.remove(word);
    notifyListeners();
  }

//  Future<void> editWord(Word word) async {
//    _isLoading = true;
//    notifyListeners();
//    try {
//      await _dictionaryRepository.editWord(word);
//    } catch (e) {
//      print('EditWordScreenPresenter: editWord(word) => $e');
//      rethrow;
//    } finally {
//      _isLoading = false;
//      notifyListeners();
//    }
//  }
//
//  Future<void> removeWord(String wordId) async {
//    _isLoading = true;
//    notifyListeners();
//    try {
//      await _dictionaryRepository.removeWord(wordId);
//    } catch (e) {
//      print('EditWordScreenPresenter: removeWord() => $e');
//      rethrow;
//    } finally {
//      _isLoading = false;
//      notifyListeners();
//    }
//  }
//
//  Future<void> addWordToDictionary(Word word) async {
//    _isLoading = true;
//    notifyListeners();
//    try {
//      await _dictionaryRepository.addNewWord(word);
//    } catch (e) {
//      print('NewWordScreenPresenter: addWordToDictionary(word) => $e');
//      rethrow;
//    } finally {
//      _isLoading = false;
//      notifyListeners();
//    }
//  }

  bool get _isScrollControllerNotActive =>
      wordTileHeight * _words.length < MediaQuery.of(context).size.height;
}
