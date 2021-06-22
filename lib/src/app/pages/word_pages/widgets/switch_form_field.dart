import 'package:flutter/material.dart';

class SwitchFormField extends FormField<bool> {
  SwitchFormField({
    Key? key,
    required bool initialValue,
  }) : super(
          key: key,
          initialValue: initialValue,
          builder: (field) {
            return Switch(
              value: field.value ?? initialValue,
              onChanged: field.didChange,
            );
          },
        );
}
