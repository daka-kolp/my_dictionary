import 'package:mydictionaryapp/src/domain/entities/word.dart';

abstract class DictionaryRepository {
  Future<List<Word>> getWords(int offset);

  Future<void> addNewWord(Word newWord);

  Future<void> editWord(Word word);

  Future<void> removeWord(String id);
}
