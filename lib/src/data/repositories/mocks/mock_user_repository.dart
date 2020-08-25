import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/data/repositories/mocks/mock_dictionary_repository.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';

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

  @override
  Future<List<Dictionary>> getAndRegisterDictionaries([int offset = 0]) async {
    await Future.delayed(Duration(seconds: 1));

    final lastIndex = offset + GetIt.I.get<GlobalConfig>().fetchStep;
    final length = _dictionaries.length;

    final endOffset = lastIndex > length ? length : lastIndex;

    if (offset > endOffset) {
      throw RangeError('offset > endOffset is ${offset > endOffset}');
    }
    final dictionaries = _dictionaries.sublist(offset, endOffset);

    dictionaries.forEach((dictionary) {
      GetIt.I.registerSingleton(
        MockDictionaryRepository(dictionary),
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
}
