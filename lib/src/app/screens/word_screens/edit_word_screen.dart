import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/app/screens/word_screens/widgets/padding_wrapper.dart';
import 'package:mydictionaryapp/src/app/screens/word_screens/widgets/title_tile.dart';
import 'package:mydictionaryapp/src/app/screens/word_screens/widgets/translations_list_form_field.dart';
import 'package:mydictionaryapp/src/app/utils/dialog_builder.dart';
import 'package:mydictionaryapp/src/app/utils/no_scroll_behavior.dart';
import 'package:mydictionaryapp/src/app/widgets/without_error_text_form_field.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/device/utils/localization.dart';

class EditWordScreen extends StatefulWidget {
  final Word word;

  const EditWordScreen({Key key, @required this.word})
      : assert(word != null),
        super(key: key);

  static PageRoute buildPageRoute(Word word) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder(word));
    }
    return MaterialPageRoute(builder: _builder(word));
  }

  static WidgetBuilder _builder(Word word) {
    return (context) => EditWordScreen(word: word);
  }

  @override
  _EditWordScreenState createState() => _EditWordScreenState();
}

class _EditWordScreenState extends State<EditWordScreen> {
  final _formStateKey = GlobalKey<FormState>();
  final _wordStateKey = GlobalKey<FormFieldState<String>>();
  final _listStateKey = GlobalKey<FormFieldState<List<Translation>>>();
  final _hintStateKey = GlobalKey<FormFieldState<String>>();

  bool _isFromValid = false;

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
    final title = Text(widget.word.word);

    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: title,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.delete_simple),
          onPressed: _showDialogOnRemoveWord,
        ),
      );
    }

    return AppBar(
      title: title,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: remove,
          onPressed: _showDialogOnRemoveWord,
        ),
      ],
    );
  }

  Future<void> _showDialogOnRemoveWord() async {
    await showDialog(
      context: context,
      builder: dialogBuilder(context, removeWordQuestion, _onRemove),
    );
  }

  void _onRemove() {
    Navigator.of(context)..pop()..pop<String>(widget.word.id);
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
              TitleTile(title: editWord, isRequired: true),
              _buildWordFormField(),
              TitleTile(title: editTranslation, isRequired: true),
              _buildTranslationsListFormField(),
              TitleTile(title: editHint),
              _buildHintFormField(),
              _buildEditWordButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _onFormChange() {
    setState(() => _isFromValid = _formStateKey.currentState.validate());
  }

  Widget _buildWordFormField() {
    return PaddingWrapper(
      child: WithoutErrorTextFormField(
        key: _wordStateKey,
        initialValue: widget.word.word,
        validator: (value) => value.isEmpty ? '' : null,
      ),
    );
  }

  Widget _buildTranslationsListFormField() {
    return PaddingWrapper(
      child: TranslationListFormField(
        key: _listStateKey,
        initialList: widget.word.translations,
      ),
    );
  }

  Widget _buildHintFormField() {
    return PaddingWrapper(
      child: TextFormField(
        key: _hintStateKey,
        initialValue: widget.word.hint,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(hintText: writeAssociationOrHint),
      ),
    );
  }

  Widget _buildEditWordButton() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: RaisedButton(
          child: Text(edit),
          onPressed: _isFromValid ? _onEdit : null,
        ),
      ),
    );
  }

  Future<void> _onEdit() async {
    final editedWord = widget.word.copyWith(
      word: _wordStateKey.currentState.value,
      translations: _listStateKey.currentState.value,
      hint: _hintStateKey.currentState.value,
    );
    Navigator.pop<Word>(context, editedWord);
  }
}
