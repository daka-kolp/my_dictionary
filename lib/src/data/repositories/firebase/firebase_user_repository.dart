import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';

class FirebaseUserRepository extends UserRepository {
  @override
  Future<List<Dictionary>> getDictionaries(
      int firstIndex,
      int offset,
      String userId,
    ) {
    // TODO: implement getDictionaries
    throw UnimplementedError();
  }

  @override
  Future<void> createNewDictionary(Dictionary dictionary, String userId) {
    // TODO: implement createNewDictionary
    throw UnimplementedError();
  }

  @override
  Future<void> removeDictionary(String id, String userId) {
    // TODO: implement removeDictionary
    throw UnimplementedError();
  }
}
