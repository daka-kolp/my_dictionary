abstract class AuthRepository {
  Future<bool> get isLoggedIn;

  Future<void> loginWith(LoginPayload loginPayload);

  Future<void> registerWith(RegisterPayload registerPayload);

  Future<bool> logOut();
}

abstract class LoginPayload {
  final String email;

  LoginPayload(this.email);
}

abstract class RegisterPayload {
  final String name;
  final String email;

  RegisterPayload(this.name, this.email);
}
