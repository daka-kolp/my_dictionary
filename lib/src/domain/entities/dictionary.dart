import 'package:meta/meta.dart';

import 'package:mydictionaryapp/src/domain/entities/word.dart';

class Dictionary {
  final String title;
  final List<Word> words;

  Dictionary({
    @required this.title,
    @required this.words,
  })  : assert(title != null),
        assert(words != null);
}
