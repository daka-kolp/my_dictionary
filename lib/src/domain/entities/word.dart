import 'package:meta/meta.dart';

class Word {
  final String id;
  final String word;
  final List<Translation> translations;
  final String hint;
  final DateTime addingTime;

  Word({
    @required this.id,
    @required this.word,
    List<Translation> translations,
    String hint,
    DateTime addingTime,
  })  : this.translations = translations ?? [],
        this.hint = hint ?? '',
        this.addingTime = addingTime ?? DateTime.utc(1970),
        assert(id != null),
        assert(word != null && word.isNotEmpty);

  Word copyWith({
    String word,
    List<Translation> translations,
    String hint,
  }) {
    return Word(
      id: id,
      word: word ?? this.word,
      translations: translations ?? this.translations,
      hint: hint ?? this.hint,
      addingTime: addingTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Word && runtimeType == other.runtimeType && word == other.word;

  @override
  int get hashCode => word.hashCode;
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

