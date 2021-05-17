import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, Object message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.toString())));
}
