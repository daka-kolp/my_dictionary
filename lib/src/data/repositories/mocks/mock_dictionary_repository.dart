import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/global_config.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';

class MockDictionaryRepository extends DictionaryRepository {
  final _words = [
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

  //TODO: remove
  List<Word> get words => _words;

  @override
  Future<List<Word>> getWords(int offset) async {
    await Future.delayed(Duration(seconds: 3));

    final lastIndex = offset + GetIt.I.get<GlobalConfig>().fetchStep;
    final length = _words.length;

    final endOffset = lastIndex > length ? length : lastIndex;
    return _words.sublist(
      offset,
      endOffset,
    );
  }

  @override
  Future<bool> addNewWord(Word newWord) async {
    await Future.delayed(Duration(seconds: 3));
    if (_words.contains(newWord)) {
      return false;
    }
    _words.add(newWord);
    return true;
  }

  @override
  Future<bool> editWord(Word word) async {
    await Future.delayed(Duration(seconds: 3));

    int wordIndex = _words.indexWhere(
      (w) => w.id == word.id,
    );

    if (wordIndex == -1) {
      return false;
    }

    _words
      ..removeAt(wordIndex)
      ..insert(wordIndex, word);
    return true;
  }

  @override
  Future<bool> removeWord(String id) async {
    await Future.delayed(Duration(seconds: 3));

    Word word;

    try {
      word = _words.firstWhere(
        (w) => w.id == id,
      );
    } on StateError {
      return false;
    }

    _words.remove(word);
    return true;
  }
}
