import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';

class FirebaseDictionaryRepository extends DictionaryRepository {
  @override
  Future<List<Word>> getWords(int firstIndex, int offset, String dictionaryId) {
    // TODO: implement getWords
    throw UnimplementedError();
  }

  @override
  Future<void> addNewWord(Word newWord, String dictionaryId) {
    // TODO: implement addNewWord
    throw UnimplementedError();
  }

  @override
  Future<void> editWord(Word word, String dictionaryId) {
    // TODO: implement editWord
    throw UnimplementedError();
  }

  @override
  Future<void> removeWord(String id, String dictionaryId) {
    // TODO: implement removeWord
    throw UnimplementedError();
  }
}

