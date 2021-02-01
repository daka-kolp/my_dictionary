import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/language.dart';

class LanguagesListButton extends StatelessWidget {
  final GlobalKey<FormFieldState<Language>> languagesListKey;
  final String hint;
  final List<Language> languages;

  const LanguagesListButton({
    Key key,
    @required this.languagesListKey,
    @required this.hint,
    @required this.languages,
  })  : assert(languagesListKey != null),
        assert(hint != null),
        assert(languages != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DropdownMenuItem<Language>>>(
      future: _asyncLanguagesListBuilder(languages),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: DropdownButtonFormField<Language>(
            key: languagesListKey,
            hint: Text(hint),
            items: snapshot.data,
            validator: (value) => value == null ? '' : null,
            onChanged: (value) {},
          ),
        );
      },
    );
  }
}

Future<List<DropdownMenuItem<Language>>> _asyncLanguagesListBuilder(
  List<Language> languages,
) async {
  return await compute(_languagesListBuilder, languages);
}

List<DropdownMenuItem<Language>> _languagesListBuilder(
  List<Language> languages,
) {
  return languages.map((language) {
    return DropdownMenuItem(
      value: language,
      child: Text(language.name),
    );
  }).toList();
}