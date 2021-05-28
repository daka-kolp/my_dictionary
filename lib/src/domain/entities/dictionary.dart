import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';

class Dictionary {
  final String id;
  final Language originalLanguage;
  final String title;
  final TtsProperties ttsProperties;
  final AuthRepository _authRepository;
  final DictionaryRepository _dictionaryRepository;

  Dictionary({
    required this.id,
    required this.originalLanguage,
    required this.title,
  })  : ttsProperties = TtsProperties(originalLanguage.code),
        _authRepository = GetIt.I<AuthRepository>(),
        _dictionaryRepository = GetIt.I.get<DictionaryRepository>();

  factory Dictionary.newInstance({
    String? title,
    Language? originalLanguage,
  }) {
    return Dictionary(
      id: GetIt.I.get<Uuid>().v1(),
      title: title ?? '',
      originalLanguage: originalLanguage ?? Language.byDefault(),
    );
  }

  Dictionary copyWith({String? title}) {
    return Dictionary(
      id: id,
      title: title ?? this.title,
      originalLanguage: originalLanguage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dictionary &&
          runtimeType == other.runtimeType &&
          title == other.title;

  @override
  int get hashCode => title.hashCode;

  Future<String> get _userId => _authRepository.userId;

  Future<List<Word>> getWords(int firstIndex, int offset) async {
    return await _dictionaryRepository.getWords(
      firstIndex,
      offset,
      await _userId,
      id,
    );
  }

  Future<void> addWord(Word word) async {
    await _dictionaryRepository.addNewWord(word, await _userId, id);
  }

  Future<void> editWord(Word word) async {
    await _dictionaryRepository.editWord(word, await _userId, id);
  }

  Future<void> removeWord(String wordId) async {
    await _dictionaryRepository.removeWord(wordId, await _userId, id);
  }

  void reset() {
    _dictionaryRepository.reset();
  }
}

class TtsProperties {
  final String language;
  final speechRate = Platform.isIOS ? 0.5 : 1.0; //speech speed
  final volume = 1.0;
  final pitch = 1.0; //voice tone

  TtsProperties(this.language);
}
