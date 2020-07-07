import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';

abstract class UserRepository {
  Future<List<Dictionary>> getDictionaries(int offset);

  Future<bool> createNewDictionary(Dictionary dictionary);

  Future<bool> removeDictionary(String id);
}
