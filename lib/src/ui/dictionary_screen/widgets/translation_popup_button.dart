import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/word.dart';

import 'package:mydictionaryapp/src/device/utils/localization.dart';

class TranslationPopupButton extends StatelessWidget {
  final List<Translation> translations;

  TranslationPopupButton({Key key, this.translations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (translations.isEmpty) {
      return IconButton(icon: Icon(Icons.translate), onPressed: null);
    }

    return PopupMenuButton(
      tooltip: showTranslation,
      icon: Icon(Icons.translate),
      itemBuilder: _translationBuilder,
    );
  }

  List<PopupMenuEntry> _translationBuilder(BuildContext context) {
    return translations.fold(
      [],
      (previousValue, element) {
        previousValue.add(_buildTranslationItem(context, element));
        if (element != translations.last) {
          previousValue.add(PopupMenuDivider(height: 1.0));
        }
        return previousValue;
      },
    );
  }

  Widget _buildTranslationItem(
    BuildContext context,
    Translation translation,
  ) {
    return PopupMenuItem<Translation>(
      enabled: false,
      value: translation,
      child: Text(
        translation.translation,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
