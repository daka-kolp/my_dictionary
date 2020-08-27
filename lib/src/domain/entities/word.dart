import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'word.g.dart';

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
        this.addingTime = addingTime ?? DateTime(1970),
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

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);
  Map<String, dynamic> toJson() => _$WordToJson(this);
}

class Translation {
  final String id;
  final String translation;

  Translation({
    @required this.id,
    @required this.translation,
  })  : assert(id != null),
        assert(translation != null);

  factory Translation.fromJson(Map<String, dynamic> json) => _$TranslationFromJson(json);
  Map<String, dynamic> toJson() => _$TranslationToJson(this);
}
