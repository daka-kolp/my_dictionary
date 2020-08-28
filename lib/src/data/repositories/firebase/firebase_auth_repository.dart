import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';

class FirebaseAuthRepository extends AuthRepository {
  @override
  // TODO: implement isLoggedIn
  Future<bool> get isLoggedIn async => false;

  @override
  Future<void> loginWith(LoginService service) {
    // TODO: implement loginWith
    throw UnimplementedError();
  }

  @override
  Future<bool> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }
}
