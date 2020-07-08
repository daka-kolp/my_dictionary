class WrongCreditialsException implements Exception {
  @override
  String toString() {
    return 'Wrong creditials';
  }
}

class UserIsAlreadyRegisteredException implements Exception {
  @override
  String toString() {
    return 'User is already registered';
  }
}
