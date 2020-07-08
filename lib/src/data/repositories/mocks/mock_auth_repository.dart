import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/utils/store_interator.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';

class MockAuthRepository extends AuthRepository {
  final Uuid _uuid;

  MockAuthRepository() : _uuid = Uuid();

  @override
  Future<void> loginWith(LoginPayload loginPayload) async {
    if (loginPayload is MockLoginPayload) {
      await _login(loginPayload);
    } else {
      throw AssertionError();
    }
  }

  @override
  Future<void> registerWith(RegisterPayload registerPayload) async {
    if (registerPayload is MockRegisterPayload) {
      await _register(registerPayload);
    } else {
      throw AssertionError();
    }
  }

  Future<void> _login(MockLoginPayload loginPayload) async {
    try {
      if (loginPayload.email != 'test@test.com') {
        throw PlatformException(
          code: 'ERROR_USER_NOT_FOUND',
        );
      }

      await StoreInteractor.setToken(_uuid.v4());
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_USER_NOT_FOUND') {
        throw WrongCreditialsException();
      }
      rethrow;
    } catch (e) {
      print('MockAuthRepository, _login: $e');
      rethrow;
    }
  }

  Future<void> _register(MockRegisterPayload registerPayload) async {
    try {
      if (registerPayload.email == 'test@test.com') {
        throw PlatformException(
          code: 'ERROR_EMAIL_ALREADY_IN_USE',
        );
      }

      await StoreInteractor.setToken(_uuid.v4());
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        throw UserIsAlreadyRegisteredException();
      }
      rethrow;
    } catch (e) {
      print('MockAuthRepository, _register: $e');
      rethrow;
    }
  }
}

class MockLoginPayload extends LoginPayload {
  MockLoginPayload(String email) : super(email);
}

class MockRegisterPayload extends RegisterPayload {
  MockRegisterPayload(String name, String email) : super(name, email);
}
