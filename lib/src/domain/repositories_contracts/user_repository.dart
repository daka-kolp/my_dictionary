import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';

abstract class UserRepository {
  Future<List<Dictionary>> getAndRegisterDictionaries(int offset);

  Future<void> createNewDictionary(Dictionary dictionary);

  Future<void> removeDictionary(String id);

  void unregisterDictionaries(List<Dictionary> dictionaries);
}
