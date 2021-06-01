import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/my_dictionary_localization.dart';

WidgetBuilder dialogBuilder(
  BuildContext context,
  String contentText,
  VoidCallback onOkPressed, {
  bool isCancelButtonExist = true,
}) {
  final locale = MyDictionaryLocalizations.of(context)!;
  final content = Text(contentText);
  final okText = Text(locale.ok);
  final cancelText = Text(locale.cancel);

  return (context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        content: content,
        actions: <Widget>[
          if (isCancelButtonExist)
            CupertinoDialogAction(
              child: cancelText,
              onPressed: Navigator.of(context).pop,
            ),
          CupertinoDialogAction(
            child: okText,
            onPressed: onOkPressed,
          )
        ],
      );
    }

    return AlertDialog(
      content: content,
      actions: <Widget>[
        if (isCancelButtonExist)
          TextButton(
            child: cancelText,
            onPressed: Navigator.of(context).pop,
          ),
        TextButton(
          child: okText,
          onPressed: onOkPressed,
        ),
      ],
    );
  };
}
