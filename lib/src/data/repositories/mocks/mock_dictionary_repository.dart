import 'package:flutter/foundation.dart';

import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';

class MockDictionaryRepository extends DictionaryRepository {
  final _dictionaries = {
    'en-GB_ru-RU': _wordsEn,
    'uk-UA_ru-RU': _wordsUa,
  };

  @override
  Future<List<Word>> getWords(
    int firstIndex,
    int offset,
    String dictionaryId,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    final words = _dictionaries[dictionaryId];
    final length = words.length;
    final lastIndex = firstIndex + offset;
    return await compute(
      _loadWords,
      {
        'words': words,
        'firstIndex': firstIndex,
        'lastIndex': lastIndex > length ? length : lastIndex,
      },
    );
  }

  @override
  Future<void> addNewWord(Word newWord, String dictionaryId) async {
    await Future.delayed(Duration(seconds: 1));
    final words = _dictionaries[dictionaryId];
    if (words.contains(newWord)) {
      throw WordAlreadyExistException(newWord.word);
    }
    words.add(newWord);
  }

  @override
  Future<void> editWord(Word word, String dictionaryId) async {
    await Future.delayed(Duration(seconds: 1));
    final words = _dictionaries[dictionaryId];
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
  Future<void> removeWord(String wordId, String dictionaryId) async {
    await Future.delayed(Duration(seconds: 1));
    final words = _dictionaries[dictionaryId];
    try {
      final word = words.firstWhere((w) => w.id == wordId);
      words.remove(word);
    } on StateError {
      throw WordNotExistException(wordId);
    }
  }
}

List<Word> _loadWords(Map<String, dynamic> data) {
  final words = data['words'];
  final first = data['firstIndex'];
  final last = data['lastIndex'];

  return words.getRange(first, last).toList();
}

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
