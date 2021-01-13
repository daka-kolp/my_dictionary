import 'package:mydictionaryapp/src/domain/entities/word.dart';

abstract class DictionaryRepository {
  Future<List<Word>> getWords(int firstIndex, int offset, String dictionaryId);

  Future<void> addNewWord(Word newWord, String dictionaryId);

  Future<void> editWord(Word word, String dictionaryId);

  Future<void> removeWord(String id, String dictionaryId);
}
