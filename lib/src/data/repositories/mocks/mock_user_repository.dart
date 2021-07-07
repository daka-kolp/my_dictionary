import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';

class MockUserRepository extends UserRepository {
  String _mainDictionaryId = 'en-GB_ru-RU';

  List<Dictionary> get _dictionaries {
    return _staticDictionaries.map((d) => d.copyWith(
      isMain: _mainDictionaryId == d.id
    )).toList();
  }

  @override
  Future<Dictionary?> getMainDictionary(String userId) async {
    await Future.delayed(Duration(seconds: 1));
    try {
      return _dictionaries.firstWhere((d) => d.id == _mainDictionaryId);
    } catch (e) {
      return null;
    }
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
      _staticDictionaries.add(dictionary);
      _mainDictionaryId = dictionary.id;
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
    _staticDictionaries
      ..removeAt(dictionaryIndex)
      ..insert(dictionaryIndex, dictionary);

    if(dictionary.isMain) {
      _mainDictionaryId = dictionary.id;
    } else if (_mainDictionaryId == dictionary.id) {
      _mainDictionaryId = '';
    }
  }

  @override
  Future<void> removeDictionary(String dictionaryId, String userId) async {
    await Future.delayed(Duration(seconds: 1));
    try {
      final dictionary = _dictionaries.firstWhere(
        (dictionary) => dictionary.id == dictionaryId,
      );
      _staticDictionaries.remove(dictionary);
      if (_mainDictionaryId == dictionaryId) _mainDictionaryId = '';
    } on StateError {
      throw DictionaryNotExistException(dictionaryId);
    }
  }

  @override
  Future<List<Language>> getDictionaryLanguages() async =>
      [Language.byDefault()];
}

final List<Dictionary> _staticDictionaries = [
  Dictionary(
    id: 'en-GB_ru-RU',
    originalLanguage: Language('en-GB', 'English(GB)'),
    title: 'English(GB)',
    isMain: false,
  ),
  Dictionary(
    id: 'uk-UA_ru-RU',
    originalLanguage: Language('uk-UA', 'Українська'),
    title: 'Ukrainian',
    isMain: false,
  ),
];
