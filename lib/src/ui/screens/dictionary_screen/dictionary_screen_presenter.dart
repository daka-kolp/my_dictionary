import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class DictionaryScreenPresenter extends ChangeNotifier {
  final Dictionary dictionary;
  final DictionaryRepository _dictionaryRepository;
  final _fetchStep = GetIt.I<GlobalConfig>().fetchStep;

  List<Word> _words = [];
  int _offset = 0;
  bool _isNewWordsAvailable = true;
  bool _isLoading = false;

  List<Word> get words => _words;

  bool get isLoading => _isLoading;

  DictionaryScreenPresenter(
    this.dictionary,
  ) : _dictionaryRepository = GetIt.I.get<DictionaryRepository>(
          instanceName: dictionary.id,
        ) {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _words = await _dictionaryRepository.getWords(_offset);
    } catch (e) {
      print('DictionaryScreenPresenter: _init() => $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadNewWords() async {
    if (_isNewWordsAvailable) {
      _isLoading = true;
      notifyListeners();

      try {
        _offset += _fetchStep;

        final List<Word> newWords = await _dictionaryRepository.getWords(
          _offset,
        );

        if (newWords.isEmpty) {
          _isNewWordsAvailable = false;
        } else {
          _words += newWords;
        }
      } catch (e) {
        print('DictionaryScreenPresenter: uploadNewWords() => $e');
        rethrow;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
