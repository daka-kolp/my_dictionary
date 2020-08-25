import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';

class FirebaseDictionaryRepository extends DictionaryRepository {
  FirebaseDictionaryRepository(Dictionary dictionary) : super(dictionary);

  @override
  Future<void> addNewWord(Word newWord) {
    // TODO: implement addNewWord
    throw UnimplementedError();
  }

  @override
  Future<void> editWord(Word word) {
    // TODO: implement editWord
    throw UnimplementedError();
  }

  @override
  Future<List<Word>> getWords(int offset) {
    // TODO: implement getWords
    throw UnimplementedError();
  }

  @override
  Future<void> removeWord(String id) {
    // TODO: implement removeWord
    throw UnimplementedError();
  }
}

