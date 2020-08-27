import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/data/repositories/firebase/firebase_dictionary_repository.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';

class FirebaseUserRepository extends UserRepository {
  List<Dictionary> _dictionaries;

  @override
  Future<List<Dictionary>> getAndRegisterDictionaries([int offset = 0]) async {
    _dictionaries = [];

    _dictionaries.forEach((dictionary) {
      GetIt.I.registerSingleton<DictionaryRepository>(
        FirebaseDictionaryRepository(),
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
}
