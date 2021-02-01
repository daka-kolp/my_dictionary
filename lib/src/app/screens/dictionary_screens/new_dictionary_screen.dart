import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mydictionaryapp/src/app/screens/dictionary_screens/new_dictionary_screen_presenter.dart';
import 'package:mydictionaryapp/src/app/screens/dictionary_screens/widgets/languages_list_button.dart';
import 'package:mydictionaryapp/src/app/screens/word_screens/widgets/title_tile.dart';
import 'package:mydictionaryapp/src/app/utils/no_scroll_behavior.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/domain/entities/language.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/device/utils/localization.dart';

class NewDictionaryScreen extends StatefulWidget {
  static PageRoute buildPageRoute() {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder);
    }
    return MaterialPageRoute(builder: _builder);
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewDictionaryScreenPresenter(),
      child: NewDictionaryScreen(),
    );
  }

  @override
  _NewDictionaryScreenState createState() => _NewDictionaryScreenState();
}

class _NewDictionaryScreenState extends State<NewDictionaryScreen> {
  final _formStateKey = GlobalKey<FormState>();
  final _targetLanguagesKey = GlobalKey<FormFieldState<Language>>();
  final _languagesKey = GlobalKey<FormFieldState<Language>>();

  bool _isFromValid = false;

  NewDictionaryScreenPresenter get _watch =>
      context.watch<NewDictionaryScreenPresenter>();
  NewDictionaryScreenPresenter get _read =>
      context.read<NewDictionaryScreenPresenter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  void _resetFocusNode() => FocusScope.of(context).requestFocus(FocusNode());

  PreferredSizeWidget _buildAppBar() {
    final title = Text(newDictionary);

    if (Platform.isIOS) {
      return CupertinoNavigationBar(middle: title);
    }
    return AppBar(title: title);
  }

  Widget _buildBody() {
    return LoadingLayout(
      isLoading: _watch.isLoading,
      child: GestureDetector(
        onTap: _resetFocusNode,
        child: ScrollConfiguration(
          behavior: NoOverScrollBehavior(),
          child: SingleChildScrollView(
            child: Form(
              key: _formStateKey,
              onChanged: _onFormChange,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TitleTile(title: addOriginalLanguage, isRequired: true),
                  _watch.languages.isNotEmpty ? _targetLanguagesListButton : _emptyTile,
                  TitleTile(title: addTranslationLanguage, isRequired: true),
                  _watch.languages.isNotEmpty ? _languagesListButton : _emptyTile,
                  TitleTile(title: enterDictionaryName, isRequired:  true),
                  //TODO: add dictionary name field
                  _emptyTile,
                  _buildAddDictionaryButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onFormChange() {
    setState(() => _isFromValid = _formStateKey.currentState.validate());
  }

  Widget get _targetLanguagesListButton {
    return LanguagesListButton(
      languagesListKey: _targetLanguagesKey,
      hint: choseTargetLanguage,
      languages: _read.languages,
    );
  }

  Widget get _languagesListButton {
    return LanguagesListButton(
      languagesListKey: _languagesKey,
      hint: choseLanguage,
      languages: _watch.languages,
    );
  }

  Widget get _emptyTile => Container(height: 64.0);

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
