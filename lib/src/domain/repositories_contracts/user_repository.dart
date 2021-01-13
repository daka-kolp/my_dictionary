import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';

abstract class UserRepository {
  Future<List<Dictionary>> getDictionaries(int firstIndex, int offset);

  Future<void> createNewDictionary(Dictionary dictionary);

  Future<void> removeDictionary(String id);
}
