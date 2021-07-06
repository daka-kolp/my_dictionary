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
        title: 'English(GB)',
        isMain: true,
      ),
      Dictionary(
        id: 'uk-UA_ru-RU',
        originalLanguage: Language('uk-UA', 'Українська'),
        title: 'Ukrainian',
        isMain: false,
      ),
    ];
  }

  @override
  Future<List<Dictionary>> getDictionaries(String userId) async {
    await Future.delayed(Duration(seconds: 1));
    return _dictionaries;
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

  @override
  Future<List<Language>> getDictionaryLanguages() async =>
      [Language.byDefault()];
}
