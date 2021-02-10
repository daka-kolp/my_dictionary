import 'package:flutter/foundation.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';

class MockUserRepository extends UserRepository {
  List<Dictionary> get _dictionaries {
    return [
      Dictionary(
        id: 'en-GB_ru-RU',
        originalLanguage: Language('en-GB', 'English(GB)'),
        translationLanguage: Language('ru', 'Russian'),
        title: 'English(GB)',
      ),
      Dictionary(
        id: 'uk-UA_ru-RU',
        originalLanguage: Language('uk-UA', 'Українська'),
        translationLanguage: Language('ru', 'Русский'),
        title: 'Ukrainian',
      ),
    ];
  }

  @override
  Future<List<Dictionary>> getDictionaries(
      int firstIndex,
      int offset,
      String userId,
    ) async {
    await Future.delayed(Duration(seconds: 1));
    final length = _dictionaries.length;
    final lastIndex = firstIndex + offset;
    final dictionaries = await compute(
      _loadDictionaries,
      {
        'dictionaries': _dictionaries,
        'firstIndex': firstIndex,
        'lastIndex': lastIndex > length ? length : lastIndex,
      },
    );
    return dictionaries;
  }

  @override
  Future<void> createNewDictionary(Dictionary dictionary, String userId) async {
    await Future.delayed(Duration(seconds: 1));
    try {
      if (_dictionaries.contains(dictionary)) {
        throw DictionaryAlreadyExistException(dictionary.title);
      }
      _dictionaries.add(dictionary);
    } on DictionaryAlreadyExistException {
      rethrow;
    }
  }

  @override
  Future<void> editDictionary(Dictionary dictionary, String userId) async {
    await Future.delayed(Duration(seconds: 1));
    final dictionaryIndex = _dictionaries.indexWhere(
      (d) => d.id == dictionary.id,
    );
    if (dictionaryIndex == -1) {
      throw DictionaryNotExistException(dictionary.title);
    }
    _dictionaries
      ..removeAt(dictionaryIndex)
      ..insert(dictionaryIndex, dictionary);
  }

  @override
  Future<void> removeDictionary(String dictionaryId, String userId) async {
    await Future.delayed(Duration(seconds: 1));
    try {
      final dictionary = _dictionaries.firstWhere(
        (dictionary) => dictionary.id == dictionaryId,
      );
      _dictionaries.remove(dictionary);
    } on StateError {
      throw DictionaryNotExistException(dictionaryId);
    }
  }
}

List<Dictionary> _loadDictionaries(Map<String, dynamic> data) {
  final dictionaries = data['dictionaries'];
  final first = data['firstIndex'];
  final last = data['lastIndex'];

  return dictionaries.getRange(first, last).toList();
}
