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

class DictionaryAlreadyExistException implements Exception {
  @override
  String toString() {
    return 'The dictionary is already exist';
  }
}

class DictionaryNotExistException implements Exception {
  @override
  String toString() {
    return 'The dictionary is not exist';
  }
}

class WordAlreadyExistException implements Exception {
  @override
  String toString() {
    return 'The word is already exist';
  }
}

class WordNotExistException implements Exception {
  @override
  String toString() {
    return 'The word is not exist';
  }
}

class LogOutException implements Exception {
  @override
  String toString() {
    return 'The user can not logout';
  }
}

class GoogleLoginException implements Exception {
  @override
  String toString() {
    return 'Google login exception';
  }
}