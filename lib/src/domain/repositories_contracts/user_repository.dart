import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';

abstract class UserRepository {
  Future<List<Dictionary>> getAndRegisterDictionaries([int offset = 0]);

  Future<void> createNewDictionary(Dictionary dictionary);

  Future<void> removeDictionary(String id);

  void unregisterDictionaries(List<Dictionary> dictionaries) {
    dictionaries.forEach((dictionary) {
      GetIt.I.unregister(instanceName: dictionary.id);
    });
  }
}
