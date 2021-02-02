import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mydictionaryapp/src/app/screens/new_dictionary_screen/new_dictionary_screen_presenter.dart';
import 'package:mydictionaryapp/src/app/screens/new_dictionary_screen/widgets/languages_list_button.dart';
import 'package:mydictionaryapp/src/app/screens/word_screens/widgets/padding_wrapper.dart';
import 'package:mydictionaryapp/src/app/screens/word_screens/widgets/title_tile.dart';
import 'package:mydictionaryapp/src/app/utils/no_scroll_behavior.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/app/widgets/without_error_text_form_field.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
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
  final _targetLanguagesStateKey = GlobalKey<FormFieldState<Language>>();
  final _languagesStateKey = GlobalKey<FormFieldState<Language>>();
  final _dictionaryNameStateKey = GlobalKey<FormFieldState<String>>();

  bool _isFromValid = false;

  NewDictionaryScreenPresenter get _watch => context.watch<NewDictionaryScreenPresenter>();

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
                  _watch.languages.isNotEmpty ? _buildTargetLanguagesListButton() : _buildEmptyTile(),
                  TitleTile(title: addTranslationLanguage, isRequired: true),
                  _watch.languages.isNotEmpty ? _buildLanguagesListButton() : _buildEmptyTile(),
                  TitleTile(title: enterDictionaryName, isRequired:  true),
                  _buildDictionaryNameFormField(),
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

  Widget _buildTargetLanguagesListButton() {
    return LanguagesListButton(
      languagesListKey: _targetLanguagesStateKey,
      hint: choseTargetLanguage,
      languages: _watch.languages,
      onChanged: (value) {
        _dictionaryNameStateKey.currentState
          ..setValue(value.name)
          ..didChange(value.name);
      } ,
    );
  }

  Widget _buildLanguagesListButton() {
    return LanguagesListButton(
      languagesListKey: _languagesStateKey,
      hint: choseLanguage,
      languages: _watch.languages,
    );
  }

  Widget _buildDictionaryNameFormField() {
    return PaddingWrapper(
      child: WithoutErrorTextFormField(
        key: _dictionaryNameStateKey,
        validator: (value) => value.isEmpty ? '' : null,
      ),
    );
  }

  Widget _buildEmptyTile() => Container(height: 64.0);

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
    final newDictionary = Dictionary.newInstance(
      title: _dictionaryNameStateKey.currentState.value,
      originalLanguage: _targetLanguagesStateKey.currentState.value,
      translationLanguage: _languagesStateKey.currentState.value,
    );
    Navigator.pop<Dictionary>(context, newDictionary);
  }
}
