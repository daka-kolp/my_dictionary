import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/ui/screens/words_screen/widgets/tts_provider.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/utils/localization/localization.dart';

part '_speak_button.dart';
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
    return Material(
      color: _getTileColor(Theme.of(context)),
      child: Padding(
        padding: const EdgeInsets.all(0.5),
        child: Row(
          children: <Widget>[
            Expanded(child: _WordWidget(word: word)),
            _SpeakButton(word: word),
            _TranslationPopupButton(translations: word.translations),
            SizedBox(width: 48.0),
            _buildEditButton(),
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

  Widget _buildEditButton() {
    return IconButton(
      tooltip: edit,
      icon: Icon(Icons.edit),
      onPressed: _onEdit,
    );
  }

  void _onEdit() {
    //TODO: edit word, delete word, add or delete translations, add or delete tags
  }
}
