import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts_improved/flutter_tts_improved.dart';
import 'package:mydictionaryapp/src/device/utils/tts_properties.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';

import 'package:mydictionaryapp/src/device/utils/localization.dart';

part '_speak_button.dart';

part '_tags_list.dart';

part '_translation_popup_button.dart';

part '_word_widget.dart';

class WordTile extends StatefulWidget {
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
  _WordTileState createState() => _WordTileState();
}

class _WordTileState extends State<WordTile> {
  FlutterTtsImproved tts;

  @override
  void initState() {
    super.initState();
    _ttsInit();
  }

  void _ttsInit() async {
    final ttsProp = TtsProperties();
    tts = FlutterTtsImproved();

    await Future.wait([
      tts.setLanguage(ttsProp.language),
      tts.setSpeechRate(ttsProp.speechRate),
      tts.setVolume(ttsProp.volume),
      tts.setPitch(ttsProp.pitch),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: _getTileColor(theme),
      child: Padding(
        padding: const EdgeInsets.all(0.5),
        child: Row(
          children: <Widget>[
            Expanded(child: _WordWidget(word: widget.word)),
            _SpeakButton(
              word: widget.word,
              tts: tts,
            ),
            _TranslationPopupButton(translations: widget.word.translations),
            SizedBox(
              width: 48.0,
              child: _TagsList(tags: widget.word.tags),
            ),
            IconButton(
              tooltip: edit,
              icon: Icon(Icons.edit),
              onPressed: () {
                //TODO: edit word, delete word, add or delete translations, add or delete tags
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getTileColor(ThemeData theme) {
    return widget.isEven
        ? theme.primaryColor.withOpacity(0.3)
        : theme.scaffoldBackgroundColor;
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }
}
