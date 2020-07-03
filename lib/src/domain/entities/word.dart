import 'package:meta/meta.dart';

class Word {
  final String word;
  final List<Translation> translations;
  final String hint;

  Word({
    @required this.word,
    List<Translation> translations,
    String hint,
  })  : this.translations = translations ?? [],
        this.hint = hint ?? '',
        assert(word != null);

  Word copyWith({
    String word,
    List<Translation> translations,
    String hint,
  }) {
    return Word(
      word: word ?? this.word,
      translations: translations ?? this.translations,
      hint: hint ?? this.hint,
    );
  }
}

class Translation {
  final String translation;

  Translation({
    @required this.translation,
  }) : assert(translation != null);
}
