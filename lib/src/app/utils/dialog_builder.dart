import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/device/utils/localization.dart';

WidgetBuilder dialogBuilder(
  BuildContext context,
  String contentText,
  VoidCallback onOkPressed, {
  bool isCancelButtonExist = true,
}) {
  assert(context != null);
  assert(contentText != null);
  assert(onOkPressed != null);

  final content = Text(contentText);
  final okText = Text(ok);
  final cancelText = Text(cancel);

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
          FlatButton(
            child: cancelText,
            onPressed: Navigator.of(context).pop,
          ),
        FlatButton(
          child: okText,
          onPressed: onOkPressed,
        ),
      ],
    );
  };
}
