import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/ui/dictionary_screen/widgets/word_tile/word_tile.dart';

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
  String get _title => widget.dictionary.title;

  List<Word> get _words => widget.dictionary.words;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final title =  Text(_title);

    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: title,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(add),
          onPressed: onAddNewWordPressed,
        ),
      );
    }
    return AppBar(
      title: title,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          tooltip: add,
          onPressed: onAddNewWordPressed,
        ),
      ],
    );
  }

  void onAddNewWordPressed() {
    //TODO: delete or add words
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
