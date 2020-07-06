import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/ui/screens/dictionary_screen/widgets/word_tile/word_tile.dart';
import 'package:mydictionaryapp/src/ui/screens/new_word_screen/new_word_screen.dart';

import 'package:mydictionaryapp/src/device/utils/localization.dart';

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
  List<Word> get _words => widget.dictionary.words;

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
    return ListView.builder(
      itemCount: _words.length,
      itemBuilder: (context, index) {
        return WordTile(
          isEven: (index + 1).isEven,
          word: _words[index],
        );
      },
    );
  }
}
