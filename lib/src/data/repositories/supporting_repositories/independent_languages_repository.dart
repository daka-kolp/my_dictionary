import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/languages_repository.dart';

class IndependentLanguagesRepository extends LanguagesRepository {
  @override
  Future<List<Language>> getLanguages() {
    return rootBundle
        .loadString('assets/target_languages.json')
        .then((v) => compute(_languagesDecoder, v));
  }

  @override
  Future<Language> getLocalLanguage() {
    return getLanguageByCode(window.locale.languageCode);
  }

  @override
  Future<Language> getLanguageByCode(String code) {
    return getLanguages().then(
      (languages) => compute(
        _getLocalLanguage,
        {'languages': languages, 'code': code},
      ),
    );
  }
}

List<Language> _languagesDecoder(String value) {
  final json = jsonDecode(value);
  return (json as List).map((v) => Language.fromJson(v)).toList();
}

Language _getLocalLanguage(Map<String, dynamic> data) {
  return (data['languages'] as List<Language>).firstWhere(
    (l) => l.code.contains(data['code'] as String),
    orElse: () => Language.byDefault(),
  );
}
