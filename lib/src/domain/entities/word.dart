import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

class Word {
  final String id;
  final String word;
  final List<Translation> translations;
  final String hint;
  final DateTime addingTime;
  final bool isLearned;

  Word({
    required this.id,
    required this.word,
    List<Translation>? translations,
    String? hint,
    DateTime? addingTime,
    bool? isLearned,
  })  : this.translations = translations ?? [],
        this.hint = hint ?? '',
        this.addingTime = addingTime ?? DateTime.utc(1970),
        this.isLearned = isLearned ?? false,
        assert(word.isNotEmpty);

  factory Word.newInstance({
    String? word,
    List<Translation>? translations,
    String? hint,
  }) {
    return Word(
      id: GetIt.I.get<Uuid>().v1(),
      word: word ?? '',
      translations: translations,
      hint: hint,
      addingTime: DateTime.now(),
    );
  }

  Word copyWith({
    String? word,
    List<Translation>? translations,
    String? hint,
    bool? isLearned,
  }) {
    return Word(
      id: id,
      word: word ?? this.word,
      translations: translations ?? this.translations,
      hint: hint ?? this.hint,
      addingTime: addingTime,
      isLearned: isLearned ?? this.isLearned,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Word &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      word == other.word &&
      translations == other.translations &&
      hint == other.hint &&
      addingTime == other.addingTime &&
      isLearned == other.isLearned;

  @override
  int get hashCode =>
      id.hashCode ^
      word.hashCode ^
      translations.hashCode ^
      hint.hashCode ^
      addingTime.hashCode ^
      isLearned.hashCode;

  bool get isHintExist => hint.isNotEmpty;
}

class Translation {
  final String id;
  final String translation;

  Translation({
    required this.id,
    required this.translation,
  });

  factory Translation.newInstance({
    String? translation,
  }) {
    return Translation(
      id: GetIt.I.get<Uuid>().v1(),
      translation: translation ?? '',
    );
  }
}
