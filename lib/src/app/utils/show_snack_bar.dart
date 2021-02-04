import 'package:flutter/material.dart';

void showErrorMessage(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
}
