abstract class AuthRepository {
  Future<void> loginWith(LoginPayload loginPayload);

  Future<void> registerWith(RegisterPayload registerPayload);

  Future<void> restorePassword(String email);
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