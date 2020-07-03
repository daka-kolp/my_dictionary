import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/word.dart';

import 'package:mydictionaryapp/src/device/utils/localization.dart';

part '_tags_list.dart';
part '_translation_popup_button.dart';
part '_word_widget.dart';

class WordTile extends StatelessWidget {
  final Word word;
  final bool isEven;

  const WordTile({
    Key key,
    @required this.word,
    bool isEven,
  })  : this.isEven = isEven ?? false,
        assert(word != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: _getTileColor(theme),
      child: Container(
        padding: EdgeInsets.all(0.5),
        child: Row(
          children: <Widget>[
            Expanded(child: _WordWidget(word: word)),
            IconButton(
              tooltip: listen,
              icon: Icon(Icons.volume_up),
              onPressed: () {
                //TODO: listen the word
              },
            ),
            _TranslationPopupButton(translations: word.translations),
            SizedBox(
              width: 48.0,
              child: _TagsList(tags: word.tags),
            ),
            IconButton(
              tooltip: edit,
              icon: Icon(Icons.edit),
              onPressed: () {
                //TODO: edit the word: edit word, delete word, add or delete translations, add or delete tags
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getTileColor(ThemeData theme) {
    return isEven
        ? theme.primaryColor.withOpacity(0.3)
        : theme.scaffoldBackgroundColor;
  }
}
