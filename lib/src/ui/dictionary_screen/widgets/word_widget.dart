import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/word.dart';

import 'package:mydictionaryapp/src/device/utils/localization.dart';

class WordWidget extends StatelessWidget {
  final Word word;

  const WordWidget({Key key, @required this.word})
      : assert(word != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => await showDialog(
        context: context,
        builder: _showHint,
      ),
      child: Container(
        height: 48.0,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(word.word),
      ),
    );
  }

  Widget _showHint(BuildContext context) {
    final contentText = Text(word.hint.isNotEmpty ? word.hint : noData);
    final okText = Text(ok);

    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        content: contentText,
        actions: <Widget>[
          CupertinoDialogAction(
            child: okText,
            onPressed: () => _onOkPressed(context),
          )
        ],
      );
    }

    return AlertDialog(
      content: contentText,
      actions: <Widget>[
        FlatButton(
          child: okText,
          onPressed: () => _onOkPressed(context),
        ),
      ],
    );
  }

  void _onOkPressed(BuildContext context) => Navigator.pop(context);
}
