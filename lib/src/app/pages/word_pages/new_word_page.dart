import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/my_dictionary_localization.dart';

import 'package:mydictionaryapp/src/app/pages/word_pages/widgets/padding_wrapper.dart';
import 'package:mydictionaryapp/src/app/pages/word_pages/widgets/title_tile.dart';
import 'package:mydictionaryapp/src/app/pages/word_pages/widgets/translations_list_form_field.dart';
import 'package:mydictionaryapp/src/app/utils/no_scroll_behavior.dart';
import 'package:mydictionaryapp/src/app/widgets/without_error_text_form_field.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';

class NewWordPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder);
    }
    return MaterialPageRoute(builder: _builder);
  }

  Widget _builder(BuildContext context) => _NewWordScreen();
}

class _NewWordScreen extends StatefulWidget {
  @override
  _NewWordScreenState createState() => _NewWordScreenState();
}

class _NewWordScreenState extends State<_NewWordScreen> {
  final _formStateKey = GlobalKey<FormState>();
  final _wordStateKey = GlobalKey<FormFieldState<String>>();
  final _listStateKey = GlobalKey<FormFieldState<List<Translation>>>();
  final _hintStateKey = GlobalKey<FormFieldState<String>>();

  bool _isFromValid = false;

  MyDictionaryLocalizations get _locale => MyDictionaryLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetFocusNode,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  void _resetFocusNode() => FocusScope.of(context).requestFocus(FocusNode());

  PreferredSizeWidget _buildAppBar() {
    final title = Text(_locale.newWord);

    if (Platform.isIOS) {
      return CupertinoNavigationBar(middle: title);
    }
    return AppBar(title: title);
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
              TitleTile(title: _locale.enterWord, isRequired: true),
              _buildWordFormField(),
              TitleTile(title: _locale.addTranslation, isRequired: true),
              _buildTranslationsListFormField(),
              TitleTile(title: _locale.addHint),
              _buildHintFormField(),
              _buildAddWordButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _onFormChange() {
    setState(() {
      _isFromValid = _formStateKey.currentState?.validate() ?? false;
    });
  }

  Widget _buildWordFormField() {
    return PaddingWrapper(
      child: WithoutErrorTextFormField(
        key: _wordStateKey,
        validator: (value) => value?.isEmpty ?? false ? '' : null,
      ),
    );
  }

  Widget _buildTranslationsListFormField() {
    return PaddingWrapper(
      child: TranslationListFormField(
        key: _listStateKey,
      ),
    );
  }

  Widget _buildHintFormField() {
    return PaddingWrapper(
      child: TextFormField(
        key: _hintStateKey,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(hintText: _locale.writeAssociationOrHint),
      ),
    );
  }

  Widget _buildAddWordButton() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: ElevatedButton(
          child: Text(_locale.add),
          onPressed: _isFromValid ? _onAdd : null,
        ),
      ),
    );
  }

  Future<void> _onAdd() async {
    final newWord = Word.newInstance(
      word: _wordStateKey.currentState?.value,
      translations: _listStateKey.currentState?.value,
      hint: _hintStateKey.currentState?.value,
    );
    Navigator.pop<Word>(context, newWord);
  }
}