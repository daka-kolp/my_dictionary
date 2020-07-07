import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/ui/screens/new_word_screen/widgets/translations_list_form_field.dart';
import 'package:mydictionaryapp/src/ui/widgets/no_scroll_behavior.dart';
import 'package:mydictionaryapp/src/ui/widgets/without_error_text_form_field.dart';

import 'package:mydictionaryapp/src/device/utils/localization.dart';

part 'widgets/_title_tile.dart';

part 'widgets/_padding_wrapper.dart';

class NewWordScreen extends StatefulWidget {
  static PageRoute<NewWordScreen> buildPageRoute() {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder);
    }
    return MaterialPageRoute(builder: _builder);
  }

  static Widget _builder(BuildContext context) {
    return NewWordScreen();
  }

  @override
  _NewWordScreenState createState() => _NewWordScreenState();
}

class _NewWordScreenState extends State<NewWordScreen> {
  final _formStateKey = GlobalKey<FormState>();
  final _wordStateKey = GlobalKey<FormFieldState<String>>();
  final _translationsListStateKey =
      GlobalKey<FormFieldState<List<Translation>>>();
  final _hintStateKey = GlobalKey<FormFieldState<String>>();

  bool _isFromValid = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetFocusNode,
      child: Form(
        key: _formStateKey,
        onChanged: _onFormChange,
        child: Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavigationBar(),
        ),
      ),
    );
  }

  void _resetFocusNode() => FocusScope.of(context).requestFocus(FocusNode());

  void _onFormChange() {
    setState(() {
      _isFromValid = _formStateKey.currentState.validate();
    });
  }

  PreferredSizeWidget _buildAppBar() {
    final title = Text(addNewWord);

    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: title,
      );
    }
    return AppBar(title: title);
  }

  Widget _buildBody() {
    return ScrollConfiguration(
      behavior: NoOverScrollBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _TitleTile(title: enterWord, isRequired: true),
            _buildWordFormField(),
            _TitleTile(title: addTranslation, isRequired: true),
            _buildTranslationsListFormField(),
            _TitleTile(title: addHint),
            _buildHintFormField(),
          ],
        ),
      ),
    );
  }

  Widget _buildWordFormField() {
    return _PaddingWrapper(
      child: WithoutErrorTextFormField(
        key: _wordStateKey,
        validator: _validateTextFormField,
        onSaved: (value) {},
      ),
    );
  }

  String _validateTextFormField(String value) {
    if (value.isEmpty) {
      return '';
    }
    return null;
  }

  Widget _buildTranslationsListFormField() {
    return _PaddingWrapper(
      child: TranslationListFormField(
        key: _translationsListStateKey,
        onSaved: (list) {},
      ),
    );
  }

  Widget _buildHintFormField() {
    return _PaddingWrapper(
      child: TextFormField(
        key: _hintStateKey,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: writeAssociationOrHint,
        ),
        onSaved: (list) {},
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        height: 48.0,
        width: double.infinity,
        child: RaisedButton(
          child: Text(add),
          onPressed: _isFromValid ?? false ? _onAdd : null,
        ),
      ),
    );
  }

  void _onAdd() {
    //TODO: add word to list
  }
}
