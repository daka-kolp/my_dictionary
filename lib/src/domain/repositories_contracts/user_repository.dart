import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';

abstract class UserRepository {
  Future<List<Dictionary>> getDictionaries(
    int firstIndex,
    int offset,
    String userId,
  );

  Future<void> createNewDictionary(Dictionary dictionary, String userId);

  Future<void> editDictionary(Dictionary editedDictionary, String userId);

  Future<void> removeDictionary(String dictionaryId, String userId);
}
