part of 'word.dart';

Word _$WordFromJson(Map<String, dynamic> json) {
  return Word(
    id: json['id'] as String,
    word: json['word'] as String,
    translations: (json['translations'] as List)
        ?.map((e) =>
            e == null ? null : Translation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    hint: json['hint'] as String,
    addingTime: json['addingTime'] == null
        ? null
        : (json['addingTime'] as Timestamp).toDate(),
  );
}

Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'translations': instance.translations?.map((e) => e?.toJson())?.toList(),
      'hint': instance.hint,
      'addingTime': Timestamp.fromDate(instance.addingTime),
    };

Translation _$TranslationFromJson(Map<String, dynamic> json) {
  return Translation(
    id: json['id'] as String,
    translation: json['translation'] as String,
  );
}

Map<String, dynamic> _$TranslationToJson(Translation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'translation': instance.translation,
    };
