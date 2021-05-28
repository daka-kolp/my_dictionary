import 'package:mydictionaryapp/src/domain/entities/word.dart';

abstract class DictionaryRepository {
  Future<List<Word>> getWords(
    int firstIndex,
    int offset,
    String userId,
    String dictionaryId,
  );

  Future<void> addNewWord(Word newWord, String userId, String dictionaryId);

  Future<void> editWord(Word word, String userId, String dictionaryId);

  Future<void> removeWord(String id, String userId, String dictionaryId);

  void reset();
}
