import 'dart:ui';

import 'package:meta/meta.dart';

class Word {
  final String id;
  final String word;
  final List<Translation> translations;
  final String hint;
  final List<Tag> tags;
  final DateTime addingTime;

  Word({
    @required this.id,
    @required this.word,
    List<Translation> translations,
    String hint,
    List<Tag> tags,
    DateTime addingTime,
  })  : this.translations = translations ?? [],
        this.hint = hint ?? '',
        this.tags = tags ?? [],
        this.addingTime = addingTime ?? DateTime(1970),
        assert(word != null);

  Word copyWith({
    String word,
    List<Translation> translations,
    String hint,
    List<Tag> tags,
  }) {
    return Word(
      id: id,
      word: word ?? this.word,
      translations: translations ?? this.translations,
      hint: hint ?? this.hint,
      tags: tags ?? this.tags,
      addingTime: addingTime,
    );
  }
}

class Translation {
  final String id;
  final String translation;

  Translation({
    @required this.id,
    @required this.translation,
  })  : assert(id != null),
        assert(translation != null);
}

class Tag {
  final String id;
  final Color color;
  final String tag;

  Tag({
    @required this.id,
    @required this.color,
    @required this.tag,
  })  : assert(id != null),
        assert(color != null),
        assert(tag != null);
}
