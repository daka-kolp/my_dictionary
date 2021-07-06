import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchFormField extends FormField<bool> {
  SwitchFormField({
    Key? key,
    required bool initialValue,
  }) : super(
          key: key,
          initialValue: initialValue,
          builder: (field) {
            if(Platform.isIOS) {
              return Builder(
                builder: (context) => CupertinoSwitch(
                  value: field.value ?? initialValue,
                  onChanged: field.didChange,
                  activeColor: Theme.of(context).accentColor,
                ),
              );
            }
            return Switch(
              value: field.value ?? initialValue,
              onChanged: field.didChange,
            );
          },
        );
}
