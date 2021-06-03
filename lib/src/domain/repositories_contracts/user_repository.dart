import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/language.dart';

abstract class UserRepository {
  Future<List<Dictionary>> getDictionaries(String userId);

  Future<void> createNewDictionary(Dictionary dictionary, String userId);

  Future<void> editDictionary(Dictionary editedDictionary, String userId);

  Future<void> removeDictionary(String dictionaryId, String userId);

  Future<List<Language>> getDictionaryLanguages();
}
