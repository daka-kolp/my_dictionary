import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class WordsScreenPresenter with ChangeNotifier {
  final Dictionary dictionary;
  final FlutterTts tts;
  final _fetchedStep = GetIt.I<GlobalConfig>().fetchStep;

  late List<Word> _words;
  bool _isInit = true;
  bool _isNewWordsAvailable = true;
  bool _isNewWordsLoading = false;
  bool _isWordsListUpdating = false;
  int _firstIndex = 0;

  List<Word> get words => _words;
  bool get isNewWordsLoading => _isNewWordsLoading;
  bool get isInit => _isInit;
  bool get isLoading => _isWordsListUpdating;

  WordsScreenPresenter(this.dictionary) : tts = FlutterTts() {
    _init();
  }

  Future<void> _init() async {
    await _initTts();
    _isNewWordsLoading = true;
    notifyListeners();
    try {
      _words = await dictionary.getWords(_firstIndex, _fetchedStep);
      if (_words.length < _fetchedStep) {
        _isNewWordsAvailable = false;
      }
      _firstIndex += _fetchedStep;
    } catch (e) {
      _words = <Word>[];
      print('WordsScreenPresenter: _init() => $e');
    } finally {
      _isNewWordsLoading = false;
      _isInit = false;
      notifyListeners();
    }
  }

  Future<void> _initTts() async {
    final ttsProp = dictionary.ttsProperties;
    await Future.wait([
      tts.setLanguage(ttsProp.language),
      tts.setSpeechRate(ttsProp.speechRate),
      tts.setVolume(ttsProp.volume),
      tts.setPitch(ttsProp.pitch),
    ]);
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
    _isWordsListUpdating = true;
    notifyListeners();
    try {
      await dictionary.addWord(newWord);
      _words.insert(0, newWord);
    } catch (e) {
      print('WordsScreenPresenter: addNewWord(newWord) => $e');
      rethrow;
    } finally {
      _isWordsListUpdating = false;
      notifyListeners();
    }
  }

  Future<void> updateWord(Word editedWord) async {
    _isWordsListUpdating = true;
    notifyListeners();
    try {
      await dictionary.editWord(editedWord);
      int wordIndex = _words.indexWhere((w) => w.id == editedWord.id);
      _words
        ..removeAt(wordIndex)
        ..insert(wordIndex, editedWord);
    } catch (e) {
      print('WordsScreenPresenter: editWord(editedWord) => $e');
      rethrow;
    } finally {
      _isWordsListUpdating = false;
      notifyListeners();
    }
  }

  Future<void> removeWord(String removedWordId) async {
    _isWordsListUpdating = true;
    notifyListeners();
    try {
      await dictionary.removeWord(removedWordId);
      _words.removeWhere((w) => w.id == removedWordId);
    } catch (e) {
      print('WordsScreenPresenter: removeWord(removedWordId) => $e');
      rethrow;
    } finally {
      _isWordsListUpdating = false;
      notifyListeners();
    }
  }

  @override
  Future <void> dispose() async{
    await tts.stop();
    super.dispose();
  }
}
