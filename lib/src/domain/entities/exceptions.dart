class WrongCredentialsException implements Exception {
  @override
  String toString() {
    return 'Wrong credentials';
  }
}

class UserIsAlreadyRegisteredException implements Exception {
  @override
  String toString() {
    return 'User is already registered';
  }
}

class LogOutException implements Exception {
  @override
  String toString() {
    return 'The user can not logout';
  }
}

class DictionaryAlreadyExistException implements Exception {
  final String dictionaryInfo;
  DictionaryAlreadyExistException(this.dictionaryInfo);

  @override
  String toString() {
    return 'The dictionary is already exist : $dictionaryInfo';
  }
}

class DictionaryNotExistException implements Exception {
  final String dictionaryInfo;
  DictionaryNotExistException(this.dictionaryInfo);

  @override
  String toString() {
    return 'The dictionary is not exist : $dictionaryInfo';
  }
}

class WordAlreadyExistException implements Exception {
  final String wordInfo;
  WordAlreadyExistException(this.wordInfo);

  @override
  String toString() {
    return 'The word is already exist : $wordInfo';
  }
}

class WordNotExistException implements Exception {
  final String wordInfo;
  WordNotExistException(this.wordInfo);

  @override
  String toString() {
    return 'The word is not exist : $wordInfo';
  }
}
