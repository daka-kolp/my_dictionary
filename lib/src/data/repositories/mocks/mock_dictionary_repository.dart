import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class MockDictionaryRepository extends DictionaryRepository {
  late final _fetchStep = GetIt.I<GlobalConfig>().fetchStep;

  int _firstIndex = 0;

  @override
  Future<List<Word>> getWords(String userId, String dictionaryId) async {
    await Future.delayed(Duration(seconds: 1));
    final words = _getWords(dictionaryId);
    final length = words.length;
    final lastIndex = _firstIndex + _fetchStep;
    final selectedWords = await compute(
      _loadWords,
      {
        'words': words,
        'firstIndex': _firstIndex,
        'lastIndex': lastIndex > length ? length : lastIndex,
      },
    );
    _firstIndex = lastIndex;
    return selectedWords;
  }

  @override
  Future<void> addNewWord(
    String userId,
    String dictionaryId,
    Word newWord,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    final words = _getWords(dictionaryId);
    if (words.contains(newWord)) {
      throw WordAlreadyExistException(newWord.word);
    }
    words.add(newWord);
  }

  @override
  Future<void> editWord(String userId, String dictionaryId, Word word) async {
    await Future.delayed(Duration(seconds: 1));
    final words = _getWords(dictionaryId);
    final wordIndex = words.indexWhere(
      (w) => w.id == word.id,
    );
    if (wordIndex == -1) {
      throw WordNotExistException(word.word);
    }
    words
      ..removeAt(wordIndex)
      ..insert(wordIndex, word);
  }

  @override
  Future<void> removeWord(
    String userId,
    String dictionaryId,
    String wordId,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    final words = _getWords(dictionaryId);
    try {
      final word = words.firstWhere((w) => w.id == wordId);
      words.remove(word);
    } on StateError {
      throw WordNotExistException(wordId);
    }
  }

  @override
  void reset() {
    _firstIndex = 0;
  }

  List<Word> _getWords(String dictionaryId) {
    return _dictionaries[dictionaryId] ?? <Word>[];
  }
}

List<Word> _loadWords(Map<String, dynamic> data) {
  final words = data['words'];
  final first = data['firstIndex'];
  final last = data['lastIndex'];

  return words.getRange(first, last).toList();
}

final _dictionaries = {
  'en-GB_ru-RU': _wordsEn,
  'uk-UA_ru-RU': _wordsUa,
};

final _wordsEn = [
  Word(
    id: '1',
    word: 'name',
    translations: [
      Translation(id: '1', translation: 'имя'),
      Translation(id: '2', translation: 'название'),
    ],
    hint: 'Дается при родждении',
  ),
  Word(
    id: '2',
    word: 'to embarrass',
    translations: [
      Translation(id: '1', translation: 'смущать'),
    ],
  ),
  Word(
    id: '3',
    word: 'flabbergasted',
    translations: [
      Translation(id: '1', translation: 'ошеломленный'),
    ],
  ),
  Word(
    id: '4',
    word: 'discombobulated',
    translations: [
      Translation(id: '1', translation: 'ходящий кругами'),
    ],
  ),
];

final _wordsUa = [
  Word(
    id: '1',
    word: 'ім\'я',
    translations: [
      Translation(id: '1', translation: 'имя'),
    ],
    hint: 'Дается при родждении',
  ),
  Word(
    id: '2',
    word: 'бентежити',
    translations: [
      Translation(id: '1', translation: 'смущать'),
    ],
  ),
  Word(
    id: '3',
    word: 'приголомшений',
    translations: [
      Translation(id: '1', translation: 'ошеломленный'),
    ],
  ),
  Word(
    id: '4',
    word: 'гудзик',
    translations: [
      Translation(id: '1', translation: 'пуговица'),
    ],
  ),
];
