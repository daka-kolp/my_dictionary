abstract class AuthRepository {
  Future<String> get userId;

  Future<void> loginWith(LoginService service);

  Future<bool> logOut();
}

enum LoginService {
  google,
  apple,
}

