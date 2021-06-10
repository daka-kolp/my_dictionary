import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/my_dictionary_localization.dart';

import 'package:mydictionaryapp/src/app/pages/words_page/widgets/tts_provider.dart';
import 'package:mydictionaryapp/src/app/utils/dialog_builder.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';

part '_speak_button.dart';
part '_translation_popup_button.dart';
part '_word_widget.dart';

class WordTile extends StatelessWidget {
  final Word word;
  final bool isEven;
  final VoidCallback onEdit;

  const WordTile({
    Key? key,
    required this.word,
    required this.onEdit,
    this.isEven = false,
  }) : super(key: key);

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
    return Builder(
      builder: (context) {
        return IconButton(
          tooltip: MyDictionaryLocalizations.of(context)!.edit,
          icon: Icon(Icons.edit),
          onPressed: onEdit,
        );
      },
    );
  }
}
