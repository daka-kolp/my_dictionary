import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';
import 'package:mydictionaryapp/src/app/utils/dimens.dart';

class WordsScreenPresenter with ChangeNotifier {
  final BuildContext context;
  final Dictionary dictionary;
  final DictionaryRepository _dictionaryRepository;
  final _fetchStep = GetIt.I<GlobalConfig>().fetchStep;

  List<Word> _words;
  int _offset = 0;
  bool _isNewWordsAvailable = true;
  bool _isNewWordsLoading = false;
  bool _isWordListUpdating = false;

  List<Word> get words => _words;
  bool get isNewWordsLoading => _isNewWordsLoading;
  bool get isLoading => _words == null || _isWordListUpdating;

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

  Future<void> addNewWord(Word newWord) async {
    _isWordListUpdating = true;
    notifyListeners();
    try {
      await _dictionaryRepository.addNewWord(newWord);
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
      await _dictionaryRepository.editWord(editedWord);
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
      await _dictionaryRepository.removeWord(removedWordId);
      _words.removeWhere((w) => w.id == removedWordId);
    } catch (e) {
      print('EditWordScreenPresenter: removeWord(removedWordId) => $e');
      rethrow;
    } finally {
      _isWordListUpdating = false;
      notifyListeners();
    }
  }

  bool get _isScrollControllerNotActive =>
      wordTileHeight * _words.length < MediaQuery.of(context).size.height;
}
