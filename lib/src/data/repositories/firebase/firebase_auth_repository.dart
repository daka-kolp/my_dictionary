import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';

class FirebaseAuthRepository extends AuthRepository {
  @override
  // TODO: implement isLoggedIn
  Future<bool> get isLoggedIn async => false;

  @override
  Future<void> loginWith(LoginPayload loginPayload) {
    // TODO: implement loginWith
    throw UnimplementedError();
  }

  @override
  Future<void> registerWith(RegisterPayload registerPayload) {
    // TODO: implement registerWith
    throw UnimplementedError();
  }
}
