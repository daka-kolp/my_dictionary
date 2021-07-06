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
  final bool isMain;
  final TtsProperties ttsProperties;
  final AuthRepository _authRepository;
  final DictionaryRepository _dictionaryRepository;

  Dictionary({
    required this.id,
    required this.originalLanguage,
    required this.title,
    required this.isMain
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
      isMain: true,
    );
  }

  Dictionary copyWith({String? title, bool? isMain}) {
    return Dictionary(
      id: id,
      title: title ?? this.title,
      originalLanguage: originalLanguage,
      isMain: isMain ?? this.isMain,
    );
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dictionary &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      title == other.title &&
      isMain == other.isMain;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ isMain.hashCode;

  Future<String> get _userId => _authRepository.userId;

  Future<List<Word>> getWords() async {
    return await _dictionaryRepository.getWords(await _userId, id);
  }

  Future<void> addWord(Word word) async {
    await _dictionaryRepository.addWord(await _userId, id, word);
  }

  Future<void> editWord(Word word) async {
    await _dictionaryRepository.editWord(await _userId, id, word);
  }

  Future<void> removeWord(String wordId) async {
    await _dictionaryRepository.removeWord(await _userId, id, wordId);
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
