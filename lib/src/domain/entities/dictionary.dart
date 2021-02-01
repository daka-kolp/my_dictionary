import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';

class Dictionary {
  final String id;
  final Language originalLanguage;
  final Language translationLanguage;
  final String title;
  final TtsProperties ttsProperties;
  final DictionaryRepository _dictionaryRepository;

  Dictionary({
    @required this.id,
    @required this.originalLanguage,
    @required this.translationLanguage,
    @required this.title,
  })  : assert(id != null),
        assert(originalLanguage != null),
        assert(translationLanguage != null),
        assert(title != null),
        ttsProperties = TtsProperties(originalLanguage.code),
        _dictionaryRepository = GetIt.I.get<DictionaryRepository>();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dictionary &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;

  Future<List<Word>> getWords(int firstIndex, int offset) async {
    return await _dictionaryRepository.getWords(firstIndex, offset, id);
  }

  Future<void> addWord(Word word) async {
    await _dictionaryRepository.addNewWord(word, id);
  }

  Future<void> editWord(Word word) async {
    await _dictionaryRepository.editWord(word, id);
  }

  Future<void> removeWord(String wordId) async {
    await _dictionaryRepository.removeWord(wordId, id);
  }
}

class TtsProperties {
  final String language;
  final speechRate = Platform.isIOS ? 0.5 : 1.0; //speech speed
  final volume = 1.0;
  final pitch = 1.0; //voice tone

  TtsProperties(this.language) : assert(language != null);
}
