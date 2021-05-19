import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/languages_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';

class User {
  static final User I = User._();

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final LanguagesRepository _languagesRepository;

  User._()
      : _authRepository = GetIt.I<AuthRepository>(),
        _userRepository = GetIt.I<UserRepository>(),
        _languagesRepository = GetIt.I<LanguagesRepository>();

  Future<String> get _id => _authRepository.userId;

  Future<bool> get isLoggedIn async => await _id.then((id) => id.isEmpty);

  Future<void> loginWithGoogle() async {
    await _authRepository.loginWith(LoginService.google);
  }

  Future<void> loginWithApple() async {
    await _authRepository.loginWith(LoginService.apple);
  }

  Future<bool> logOut() async {
    return _authRepository.logOut();
  }

  Future<List<Dictionary>> getDictionaries(int firstIndex, int offset) async {
    return _userRepository.getDictionaries(firstIndex, offset, await _id);
  }

  Future<void> createDictionary(Dictionary dictionary) async {
    await _userRepository.createNewDictionary(dictionary, await _id);
  }

  Future<void> editDictionary(Dictionary editedDictionary) async {
    await _userRepository.editDictionary(editedDictionary, await _id);
  }

  Future<void> removeDictionary(String dictionaryId) async {
    await _userRepository.removeDictionary(dictionaryId, await _id);
  }

  Future<Language> getLocalLanguage() async {
    return _languagesRepository.getLocalLanguage();
  }

  Future<List<Language>> getLanguages() async {
    return _languagesRepository.getLanguages();
  }
}
