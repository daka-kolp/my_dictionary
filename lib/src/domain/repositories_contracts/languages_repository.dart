import 'package:mydictionaryapp/src/domain/entities/language.dart';

abstract class LanguagesRepository {
  Future<List<Language>> getLanguages();

  Future<Language> getLocalLanguage();
}
