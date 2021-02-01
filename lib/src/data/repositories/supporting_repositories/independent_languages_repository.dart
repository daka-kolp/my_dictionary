import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/languages_repository.dart';

class IndependentLanguagesRepository extends LanguagesRepository {
  @override
  Future<List<Language>> getLanguages() async {
    return await rootBundle.loadString('assets/target_languages.json')
        .then((v) => compute(_languagesDecoder, v));
  }
}

List<Language> _languagesDecoder(String value) {
  final json = jsonDecode(value);
  return (json as List).map((v) => Language.fromJson(v)).toList();
}
