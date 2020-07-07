import 'package:meta/meta.dart';

import 'package:mydictionaryapp/src/domain/entities/word.dart';

class Dictionary {
  final String id;
  final String originalLanguage;
  final String translationLanguage;
  final String title;
  final List<Word> words;
  final List<Tag> tags;

  Dictionary({
    @required this.id,
    @required this.originalLanguage,
    @required this.translationLanguage,
    @required this.title,
    List<Word> words,
    List<Tag> tags,
  })  : this.words = words ?? [],
        this.tags = tags ?? [],
        assert(id != null),
        assert(originalLanguage != null),
        assert(translationLanguage != null),
        assert(title != null);
}
