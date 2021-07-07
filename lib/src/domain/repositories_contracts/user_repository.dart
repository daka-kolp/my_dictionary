import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/device/utils/store_interator.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/entities/user.dart';

abstract class UserRepository {
  late final _storeInteractor = GetIt.I<StoreInteractor>();

  Future<UserData?> getUserData() => _storeInteractor.getUserData();

  Future<Dictionary?> getMainDictionary(String userId);

  Future<List<Dictionary>> getDictionaries(String userId);

  Future<void> createNewDictionary(Dictionary dictionary, String userId);

  Future<void> editDictionary(Dictionary editedDictionary, String userId);

  Future<void> removeDictionary(String dictionaryId, String userId);

  Future<List<Language>> getDictionaryLanguages();
}
