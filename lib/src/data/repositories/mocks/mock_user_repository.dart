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

    List<Dictionary> dictionaries;
    if(lastIndex > length) {
      dictionaries = _dictionaries.getRange(firstIndex, length).toList();
    } else {
      _firstIndex = lastIndex;
      dictionaries = _dictionaries.getRange(firstIndex, lastIndex).toList();
    }

    dictionaries.forEach((dictionary) {
      GetIt.I.registerFactory(
        () => MockDictionaryRepository(dictionary),
        instanceName: dictionary.id,
      );
    });

    return dictionaries;
  }

  @override
  Future<void> createNewDictionary(Dictionary dictionary) async {
    await Future.delayed(Duration(seconds: 1));

    if (_dictionaries.contains(dictionary)) {
      throw DictionaryAlreadyExistException();
    }
    _dictionaries.add(dictionary);
  }

  @override
  Future<void> removeDictionary(String id) async {
    await Future.delayed(Duration(seconds: 1));

    try {
      Dictionary dictionary = _dictionaries.firstWhere(
        (dictionary) => dictionary.id == id,
      );
      _dictionaries.remove(dictionary);
      GetIt.I.unregister(instanceName: dictionary.id);
    } on StateError {
      throw DictionaryNotExistException();
    }
  }

  @override
  void unregisterDictionaries(List<Dictionary> dictionaries) {
    _firstIndex = 0;
    super.unregisterDictionaries(dictionaries);
  }
}
