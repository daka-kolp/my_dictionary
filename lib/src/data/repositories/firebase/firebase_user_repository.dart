import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';

class FirebaseUserRepository extends UserRepository {
  @override
  Future<List<Dictionary>> getDictionaries(int firstIndex, int offset) {
    // TODO: implement getDictionaries
    throw UnimplementedError();
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
