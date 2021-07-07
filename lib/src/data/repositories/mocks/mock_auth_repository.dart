import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/device/utils/store_interator.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/user.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';

class MockAuthRepository extends AuthRepository {
  late final _storeInteractor = GetIt.I<StoreInteractor>();

  @override
  Future<String> get userId async => _storeInteractor.getToken();

  @override
  Future<void> loginWith(LoginService service) async {
    await Future.delayed(Duration(seconds: 1));
    try {
      await _storeInteractor.setUserData(
        UserData('Name Surname', 'test@test.com'),
      );
      await _login(_MockLoginPayload('test@test.com'));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> logOut() async {
    await Future.delayed(Duration(seconds: 1));
    return await _storeInteractor.clear();
  }

  Future<void> _login(_MockLoginPayload loginPayload) async {
    try {
      if (loginPayload.email != 'test@test.com') {
        throw WrongCredentialsException();
      }
      await _storeInteractor.setToken('token_123');
    } catch (e) {
      print('MockAuthRepository: _login => $e');
      rethrow;
    }
  }
}

class _MockLoginPayload {
  final String email;

  _MockLoginPayload(this.email);
}
