const GOOGLE = 'Google';

abstract class AuthRepository {
  Future<bool> get isLoggedIn;

  Future<void> loginWith(String service);

  Future<bool> logOut();
}

