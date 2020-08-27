import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class WordsScreenPresenter with ChangeNotifier {
  final DictionaryRepository _dictionaryRepository;
  final _authRepository = GetIt.I<AuthRepository>();
  final _fetchStep = GetIt.I<GlobalConfig>().fetchStep;

  List<Word> _words;
  int _offset = 0;
  bool _isNewWordsAvailable = true;
  bool _isNewWordsLoading = false;
  bool _isLoading = false;

  Dictionary get dictionary => _dictionaryRepository.dictionary;
  List<Word> get words => _words;
  bool get isNewWordsLoading => _isNewWordsLoading;
  bool get isLoading => _words == null || _isLoading;

  WordsScreenPresenter() : _dictionaryRepository = GetIt.I.get<DictionaryRepository>() {
    _init();
  }

  Future<void> _init() async {
    _isNewWordsLoading = true;
    notifyListeners();
    try {
      try {
        _words = await _dictionaryRepository.getWords(_offset);

        if (_words.length < _fetchStep) {
          _isNewWordsAvailable = false;
          notifyListeners();
        }
      } catch (e) {
        print('WordsScreenPresenter: _init() => inner "try" : ');
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
    if(_isNewWordsLoading) return;
    if (_isNewWordsAvailable) {
      _isNewWordsLoading = true;
      notifyListeners();

      try {
        _offset += _fetchStep;
        final newWords = await _dictionaryRepository.getWords(_offset);
        if (newWords.length < _fetchStep) {
          _isNewWordsAvailable = false;
          notifyListeners();
        }
       _words += newWords;

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

  Future<void> changeUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      bool isLoggedOut = await _authRepository.logOut();
      if(!isLoggedOut) {
        throw LogOutException();
      }
    } catch (e) {
      print('DictionariesScreenPresenter: changeUser() => $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  @override
  void dispose() {
    _dictionaryRepository.reset();
    super.dispose();
  }
}
