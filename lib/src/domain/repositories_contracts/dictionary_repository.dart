import 'package:mydictionaryapp/src/domain/entities/word.dart';

abstract class DictionaryRepository {
  Future<List<Word>> getWords(String userId, String dictionaryId);

  Future<void> addWord(String userId, String dictionaryId, Word newWord);

  Future<void> editWord(String userId, String dictionaryId, Word word);

  Future<void> removeWord(String userId, String dictionaryId, String id);

  void reset();
}
