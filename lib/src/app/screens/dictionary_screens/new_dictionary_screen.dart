import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/app/screens/word_screens/widgets/title_tile.dart';
import 'package:mydictionaryapp/src/app/widgets/no_scroll_behavior.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_layout.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/app/localization/localization.dart';

class NewDictionaryScreen extends StatefulWidget {
  static PageRoute buildPageRoute() {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder);
    }
    return MaterialPageRoute(builder: _builder);
  }

  static Widget _builder(BuildContext context) {
    return NewDictionaryScreen();
  }

  @override
  _NewDictionaryScreenState createState() => _NewDictionaryScreenState();
}

class _NewDictionaryScreenState extends State<NewDictionaryScreen> {
  final _formStateKey = GlobalKey<FormState>();

  bool _isFromValid = false;

  @override
  Widget build(BuildContext context) {
    return LoadingLayout(
      isLoading: false,
      child: GestureDetector(
        onTap: _resetFocusNode,
        child: Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
        ),
      ),
    );
  }

  void _resetFocusNode() => FocusScope.of(context).requestFocus(FocusNode());

  PreferredSizeWidget _buildAppBar() {
    final title = Text(newDictionary);

    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: title,
      );
    }
    return AppBar(
      title: title,
    );
  }

  Widget _buildBody() {
    return ScrollConfiguration(
      behavior: NoOverScrollBehavior(),
      child: SingleChildScrollView(
        child: Form(
          key: _formStateKey,
          onChanged: _onFormChange,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleTile(title: addOriginalLanguage),
              Container(height: 48.0),
              TitleTile(title: addTranslationLanguage),
              Container(height: 48.0),
              TitleTile(title: enterDictionaryName),
              Container(height: 48.0),
              _buildAddDictionaryButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _onFormChange() {
    setState(() => _isFromValid = _formStateKey.currentState.validate());
  }

  Widget _buildAddDictionaryButton() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: RaisedButton(
          child: Text(add),
          onPressed: _isFromValid ? _onAdd : null,
        ),
      ),
    );
  }

  Future<void> _onAdd() async {
    //TODO: add new dictionary
  }
}
