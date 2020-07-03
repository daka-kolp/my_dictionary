import 'dart:ui';

import 'package:meta/meta.dart';

class Word {
  final String word;
  final List<Translation> translations;
  final String hint;
  final List<Tag> tags;

  Word({
    @required this.word,
    List<Translation> translations,
    String hint,
    List<Tag> tags,
  })  : this.translations = translations ?? [],
        this.hint = hint ?? '',
        this.tags = tags ?? [],
        assert(word != null);

  Word copyWith({
    String word,
    List<Translation> translations,
    String hint,
    List<Tag> tags,
  }) {
    return Word(
      word: word ?? this.word,
      translations: translations ?? this.translations,
      hint: hint ?? this.hint,
      tags: tags ?? this.tags,
    );
  }
}

class Translation {
  final String translation;

  Translation({
    @required this.translation,
  }) : assert(translation != null);
}

class Tag {
  final Color color;
  final String tag;

  Tag({
    @required this.color,
    @required this.tag,
  })  : assert(color != null),
        assert(tag != null);
}
