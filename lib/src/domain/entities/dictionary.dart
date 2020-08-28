import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';

class Dictionary {
  final String id;
  final String originalLanguage;
  final String translationLanguage;
  final String title;
  final TtsProperties ttsProperties;

  Dictionary({
    @required this.id,
    @required this.originalLanguage,
    @required this.translationLanguage,
    @required this.title,
  })  : ttsProperties = TtsProperties(originalLanguage),
        assert(id != null),
        assert(originalLanguage != null),
        assert(translationLanguage != null),
        assert(title != null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dictionary &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;

  Future<List<Word>> getWords(int offset) async {
    final dictionaryRepository =
        GetIt.I.get<DictionaryRepository>(instanceName: id);
    return await dictionaryRepository.getWords(offset);
  }
}

class TtsProperties {
  final String language;
  final speechRate = Platform.isIOS ? 0.5 : 1.0; //speech speed
  final volume = 1.0;
  final pitch = 1.0; //voice tone

  TtsProperties(this.language);
}
