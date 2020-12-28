import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/data/repositories/mocks/mock_dictionary_repository.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';

class MockUserRepository extends UserRepository {
  final _dictionaries = [
    Dictionary(
      id: 'en-GB_ru-RU',
      originalLanguage: 'en-GB',
      translationLanguage: 'ru',
      title: 'English(GB)',
    ),
    Dictionary(
      id: 'uk-UA_ru-RU',
      originalLanguage: 'uk-UA',
      translationLanguage: 'ru',
      title: 'Ukrainian',
    ),
  ];

  int _firstIndex = 0;

  @override
  Future<List<Dictionary>> getAndRegisterDictionaries(int offset) async {
    await Future.delayed(Duration(seconds: 1));
    final length = _dictionaries.length;
    final firstIndex = _firstIndex;
    final lastIndex = _firstIndex + offset;
    if (lastIndex < length) {
      _firstIndex = lastIndex;
    }
    final dictionaries = await compute(
      _loadDictionaries,
      {
        'dictionaries': _dictionaries,
        'firstIndex': firstIndex,
        'lastIndex': lastIndex > length ? length : lastIndex,
      },
    );
    return dictionaries
      ..forEach((dictionary) {
        GetIt.I.registerFactory(
          () => MockDictionaryRepository(dictionary),
          instanceName: dictionary.id,
        );
      });
  }

  @override
  Future<void> createNewDictionary(Dictionary dictionary) async {
    await Future.delayed(Duration(seconds: 1));
    try {
      await compute(
        _addDictionary,
        {'dictionaries': _dictionaries, 'newDictionary': dictionary},
      );
    } on DictionaryAlreadyExistException {
      rethrow;
    }
    GetIt.I.registerFactory(
      () => MockDictionaryRepository(dictionary),
      instanceName: dictionary.id,
    );
  }

  @override
  Future<void> removeDictionary(String id) async {
    await Future.delayed(Duration(seconds: 1));
    try {
      await compute(
        _removeDictionary,
        {'dictionaries': _dictionaries, 'dictionaryId': id},
      );
    } on DictionaryNotExistException {
      rethrow;
    }
    GetIt.I.unregister(instanceName: id);
  }

  @override
  void unregisterDictionaries(List<Dictionary> dictionaries) {
    _firstIndex = 0;
    super.unregisterDictionaries(dictionaries);
  }
}

List<Dictionary> _loadDictionaries(Map<String, dynamic> data) {
  final dictionaries = data['dictionaries'];
  final first = data['firstIndex'];
  final last = data['lastIndex'];

  return dictionaries.getRange(first, last).toList();
}

void _addDictionary(Map<String, dynamic> data) {
  final dictionaries = data['dictionaries'];
  final dictionary = data['newDictionary'];
  if (dictionaries.contains(dictionary)) {
    throw DictionaryAlreadyExistException();
  }
  dictionaries.add(dictionary);
}

void _removeDictionary(Map<String, dynamic> data) {
  final dictionaries = data['dictionaries'];
  final dictionaryId = data['dictionaryId'];
  try {
    Dictionary dictionary = dictionaries.firstWhere(
      (dictionary) => dictionary.id == dictionaryId,
    );
    dictionaries.remove(dictionary);
  } on StateError {
    throw DictionaryNotExistException();
  }
}
