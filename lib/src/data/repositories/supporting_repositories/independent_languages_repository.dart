import 'dart:convert';
import 'dart:ui';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/languages_repository.dart';

class IndependentLanguagesRepository extends LanguagesRepository {
  @override
  Future<List<Language>> getLanguages() async {
    return await rootBundle
        .loadString('assets/target_languages.json')
        .then((v) => compute(_languagesDecoder, v));
  }

  @override
  Future<Language> getLocalLanguage() async {
    return await getLanguages().then(
      (languages) => compute(
        _getLocalLanguage,
        {'languages': languages, 'code': window.locale.languageCode},
      ),
    );
  }
}

List<Language> _languagesDecoder(String value) {
  final json = jsonDecode(value);
  return (json as List).map((v) => Language.fromJson(v)).toList();
}

Language _getLocalLanguage(Map<String, dynamic> data) {
  final result = (data['languages'] as List<Language>).firstWhereOrNull(
    (l) => l.code!.contains(data['code'] as String),
  );
  return result ?? Language('en');
}
