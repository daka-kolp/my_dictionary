import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';

abstract class DictionaryRepository {
  final Dictionary _dictionary;

  DictionaryRepository(
    Dictionary dictionary,
  ) : _dictionary = dictionary;

  Dictionary get dictionary => _dictionary;

  Future<List<Word>> getWords([int offset]);

  Future<void> addNewWord(Word newWord);

  Future<void> editWord(Word word);

  Future<void> removeWord(String id);

  void reset();
}
