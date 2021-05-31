import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:mydictionaryapp/src/domain/entities/language.dart';

class DictionariesService {
  Future<List<Language>> getLanguages() {
    return rootBundle
        .loadString('assets/target_languages.json')
        .then((v) => compute(_languagesDecoder, v));
  }

  Future<Language> getLanguageByCode(String code) {
    return getLanguages().then(
      (languages) => compute(
        _getLanguageByCode,
        {'languages': languages, 'code': code},
      ),
    );
  }
}

List<Language> _languagesDecoder(String value) {
  final json = jsonDecode(value);
  return (json as List).map((v) => Language.fromJson(v)).toList();
}

Language _getLanguageByCode(Map<String, dynamic> data) {
  return (data['languages'] as List<Language>).firstWhere(
    (l) => l.code.contains(data['code'] as String),
    orElse: () => Language.byDefault(),
  );
}
