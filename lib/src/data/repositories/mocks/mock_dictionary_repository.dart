import 'package:flutter/foundation.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';

class MockDictionaryRepository extends DictionaryRepository {
  int _firstIndex = 0;

  MockDictionaryRepository(
    Dictionary dictionary,
  ) : super(dictionary);

  final _dictionaries = {
    'en-GB_ru-RU': _wordsEn,
    'uk-UA_ru-RU': _wordsUa,
  };

  List<Word> get _words => _dictionaries[dictionary.id];

  @override
  Future<List<Word>> getWords(int offset) async {
    await Future.delayed(Duration(seconds: 1));
    final length = _words.length;
    final firstIndex = _firstIndex;
    final lastIndex = _firstIndex + offset;
    if (lastIndex < length) {
      _firstIndex = lastIndex;
    }
    return await compute(
      _loadWords,
      {
        'words': _words,
        'firstIndex': firstIndex,
        'lastIndex': lastIndex > length ? length : lastIndex,
      },
    );
  }

  @override
  Future<void> addNewWord(Word newWord) async {
    await Future.delayed(Duration(seconds: 1));
    await compute(
      _addWord,
      {'words': _words, 'newWord': newWord},
    );
  }

  @override
  Future<void> editWord(Word word) async {
    await Future.delayed(Duration(seconds: 1));
    await compute(
      _editWord,
      {'words': _words, 'word': word},
    );
  }

  @override
  Future<void> removeWord(String id) async {
    await Future.delayed(Duration(seconds: 1));
    await compute(_removeWord, {'words': _words, 'wordId': id});
  }
}

List<Word> _loadWords(Map<String, dynamic> data) {
  final words = data['words'];
  final first = data['firstIndex'];
  final last = data['lastIndex'];

  return words.getRange(first, last).toList();
}

void _addWord(Map<String, dynamic> data) {
  final words = data['words'];
  final newWord = data['newWord'];
  if (words.contains(newWord)) {
    throw WordAlreadyExistException();
  }
  words.add(newWord);
}

void _editWord(Map<String, dynamic> data) {
  final words = data['words'];
  final word = data['word'];
  final wordIndex = words.indexWhere(
    (w) => w.id == word.id,
  );
  if (wordIndex == -1) {
    throw WordNotExistException();
  }
  words
    ..removeAt(wordIndex)
    ..insert(wordIndex, word);
}

void _removeWord(Map<String, dynamic> data) {
  final words = data['words'];
  final wordId = data['wordId'];
  try {
    Word word = words.firstWhere((w) => w.id == wordId);
    words.remove(word);
  } on StateError {
    throw WordNotExistException();
  }
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
