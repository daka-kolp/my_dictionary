import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/app/screens/new_dictionary_screen/widgets/without_error_dropdown_button_form_field.dart';
import 'package:mydictionaryapp/src/app/screens/word_screens/widgets/padding_wrapper.dart';
import 'package:mydictionaryapp/src/domain/entities/language.dart';

class LanguagesListButton extends StatelessWidget {
  final GlobalKey<FormFieldState<Language>> languagesListKey;
  final String hint;
  final List<Language> languages;
  final ValueChanged<Language> onChanged;

  const LanguagesListButton({
    Key key,
    @required this.languagesListKey,
    @required this.hint,
    @required this.languages,
    this.onChanged,
  })  : assert(languagesListKey != null),
        assert(hint != null),
        assert(languages != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DropdownMenuItem<Language>>>(
      future: _asyncLanguagesListBuilder(languages),
      builder: (context, snapshot) {
        return PaddingWrapper(
          child: WithoutErrorDropdownButtonFormField<Language>(
            key: languagesListKey,
            hint: Text(hint),
            items: snapshot.data,
            validator: (value) => value == null ? '' : null,
            onChanged: onChanged,
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
