import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class MockDictionaryRepository extends DictionaryRepository {
  final Dictionary _dictionary;

  MockDictionaryRepository(
    Dictionary dictionary,
  ) : _dictionary = dictionary;

  final _dictionaries = {
    'en-GB_ru-RU': _wordsEn,
    'uk-UA_ru-RU': _wordsUa,
  };

  List<Word> get _words => _dictionaries[_dictionary.id];

  @override
  Future<List<Word>> getWords(int offset) async {
    final lastIndex = offset + GetIt.I.get<GlobalConfig>().fetchStep;
    final length = _words.length;

    final endOffset = lastIndex > length ? length : lastIndex;
    return _words.sublist(
      offset,
      endOffset,
    );
  }

  @override
  Future<void> addNewWord(Word newWord) async {
    await Future.delayed(Duration(seconds: 3));

    if (_words.contains(newWord)) {
      throw WordAlreadyExistException();
    }
    _words.add(newWord);
  }

  @override
  Future<void> editWord(Word word) async {
    await Future.delayed(Duration(seconds: 3));

    int wordIndex = _words.indexWhere(
      (w) => w.id == word.id,
    );
    if (wordIndex == -1) {
      throw WordNotExistException();
    }
    _words
      ..removeAt(wordIndex)
      ..insert(wordIndex, word);
  }

  @override
  Future<void> removeWord(String id) async {
    await Future.delayed(Duration(seconds: 3));

    Word word;
    try {
      word = _words.firstWhere(
        (w) => w.id == id,
      );
    } on StateError {
      throw WordNotExistException();
    }
    _words.remove(word);
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
