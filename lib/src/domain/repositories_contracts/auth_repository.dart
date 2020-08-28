abstract class AuthRepository {
  Future<bool> get isLoggedIn;

  Future<void> loginWith(LoginService service);

  Future<bool> logOut();
}

enum LoginService {
  google,
  apple,
}

