import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/data/repositories/local/local_dictionary_repository.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';

class LocalUserRepository extends UserRepository {
  List<Dictionary> _dictionaries;

  @override
  Future<List<Dictionary>> getAndRegisterDictionaries(int offset) async {
    _dictionaries = [];

    _dictionaries.forEach((dictionary) {
      GetIt.I.registerSingleton<DictionaryRepository>(
        LocalDictionaryRepository(),
        instanceName: dictionary.id,
      );
    });

    return _dictionaries;
  }

  @override
  Future<void> createNewDictionary(Dictionary dictionary) {
    // TODO: implement createNewDictionary
    throw UnimplementedError();
  }

  @override
  Future<void> removeDictionary(String id) {
    // TODO: implement removeDictionary
    throw UnimplementedError();
  }

  @override
  void unregisterDictionaries(List<Dictionary> dictionaries) {
    // TODO: implement unregisterDictionaries
    throw UnimplementedError();
  }
}
