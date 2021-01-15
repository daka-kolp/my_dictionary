import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';

class User {
  static final User I = User._();

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  User._()
      : _authRepository = GetIt.I<AuthRepository>(),
        _userRepository = GetIt.I<UserRepository>();

  Future<String> get id => _authRepository.userId;

  Future<bool> get isLoggedIn async => await id != null;

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
    return _userRepository.getDictionaries(firstIndex, offset, await id);
  }

  Future<void> createDictionary(Dictionary dictionary) async {
    await _userRepository.createNewDictionary(dictionary, await id);
  }

  Future<void> removeDictionary(String dictionaryId) async {
    _userRepository.removeDictionary(dictionaryId, await id);
  }
}
