import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';

class User {
  static final User I = User._();

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  User._()
      : _authRepository = GetIt.I<AuthRepository>(),
        _userRepository = GetIt.I<UserRepository>();

  Future<String> get _id => _authRepository.userId;

  Future<bool> get isLoggedIn => _id.then((id) => id.isNotEmpty);

  Future<void> loginWithGoogle() async {
    await _authRepository.loginWith(LoginService.google);
  }

  Future<void> loginWithApple() async {
    await _authRepository.loginWith(LoginService.apple);
  }

  Future<bool> logOut() async {
    return _authRepository.logOut();
  }

  Future<UserData?> get userData => _userRepository.getUserData();

  Future<Dictionary?> get mainDictionary async {
    return _userRepository.getMainDictionary(await _id);
  }

  Future<List<Dictionary>> get dictionaries async {
    return _userRepository.getDictionaries(await _id);
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

  Future<List<Language>> get languages async {
    return _userRepository.getDictionaryLanguages();
  }
}

class UserData {
  final String name;
  final String email;

  UserData(this.name, this.email);

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(json['name'] as String, json['email'] as String);
  }

  Map<String, dynamic> toJson() => {'name': name, 'email': email};
}
