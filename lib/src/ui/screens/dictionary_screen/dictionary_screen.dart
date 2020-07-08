import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/ui/screens/dictionary_screen/widgets/tts_provider.dart';
import 'package:mydictionaryapp/src/ui/screens/dictionary_screen/widgets/word_tile/word_tile.dart';
import 'package:mydictionaryapp/src/ui/screens/new_word_screen/new_word_screen.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/data/repositories/mocks/mock_dictionary_repository.dart';
import 'package:mydictionaryapp/src/utils/localization/localization.dart';

class DictionaryScreen extends StatefulWidget {
  final Dictionary dictionary;

  const DictionaryScreen({
    Key key,
    @required this.dictionary,
  })  : assert(dictionary != null),
        super(key: key);

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  bool get _isIOS => Platform.isIOS;

  String get _title => widget.dictionary.title;

  //TODO: remove
  List<Word> get _words => MockDictionaryRepository().words;

  FlutterTts _tts;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    final ttsProp = widget.dictionary.ttsProperties;
    _tts = FlutterTts();

    await Future.wait([
      _tts.setLanguage(ttsProp.language),
      _tts.setSpeechRate(ttsProp.speechRate),
      _tts.setVolume(ttsProp.volume),
      _tts.setPitch(ttsProp.pitch),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _isIOS ? null : _buildFloatingActionButton(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final title = Text(_title);

    if (_isIOS) {
      return CupertinoNavigationBar(
        middle: title,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(add),
          onPressed: _onAddNewWordPressed,
        ),
      );
    }
    return AppBar(title: title);
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: _onAddNewWordPressed,
    );
  }

  void _onAddNewWordPressed() {
    Navigator.of(context).push(NewWordScreen.buildPageRoute());
  }

  Widget _buildBody() {
    return TtsProvider(
      tts: _tts,
      child: ListView.builder(
        itemCount: _words.length,
        itemBuilder: (context, index) {
          return WordTile(
            isEven: (index + 1).isEven,
            word: _words[index],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}
