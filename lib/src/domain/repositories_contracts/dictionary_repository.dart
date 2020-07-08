import 'package:mydictionaryapp/src/domain/entities/word.dart';

abstract class DictionaryRepository {
  Future<List<Word>> getWords(int offset);

  Future<bool> addNewWord(Word newWord);

  Future<bool> editWord(Word word);

  Future<bool> removeWord(String id);
}
