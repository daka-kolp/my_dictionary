import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/my_dictionary_localization.dart';

import 'package:mydictionaryapp/src/app/pages/word_pages/widgets/padding_wrapper.dart';
import 'package:mydictionaryapp/src/app/pages/word_pages/widgets/title_tile.dart';
import 'package:mydictionaryapp/src/app/pages/word_pages/widgets/translations_list_form_field.dart';
import 'package:mydictionaryapp/src/app/utils/dialog_builder.dart';
import 'package:mydictionaryapp/src/app/utils/no_scroll_behavior.dart';
import 'package:mydictionaryapp/src/app/widgets/switch_form_field.dart';
import 'package:mydictionaryapp/src/app/widgets/without_error_text_form_field.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';

class EditWordPage extends Page {
  final Word word;

  const EditWordPage(this.word);

  @override
  Route createRoute(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder);
    }
    return MaterialPageRoute(builder: _builder);
  }

  Widget _builder(BuildContext context) {
    return _EditWordScreen(word: word);
  }
}

class _EditWordScreen extends StatefulWidget {
  final Word word;

  const _EditWordScreen({Key? key, required this.word}) : super(key: key);

  @override
  _EditWordScreenState createState() => _EditWordScreenState();
}

class _EditWordScreenState extends State<_EditWordScreen> {
  final _formStateKey = GlobalKey<FormState>();
  final _isWordLearnedStateKey = GlobalKey<FormFieldState<bool>>();
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
          tooltip: _locale.remove,
          onPressed: _showDialogOnRemoveWord,
        ),
      ],
    );
  }

  Future<void> _showDialogOnRemoveWord() async {
    await showDialog(
      context: context,
      builder: dialogBuilder(context, _locale.removeWordQuestion, _onRemove),
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
              _buildWordIsLearnedSwitch(),
              TitleTile(title: _locale.editWord, isRequired: true),
              _buildWordFormField(),
              TitleTile(title: _locale.editTranslation, isRequired: true),
              _buildTranslationsListFormField(),
              TitleTile(title: _locale.editHint),
              _buildHintFormField(),
              _buildEditWordButton(),
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

  Widget _buildWordIsLearnedSwitch() {
    return PaddingWrapper(
      child: Row(
        children: [
          Expanded(
            child: Text(
              _locale.isWordLearned,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          SwitchFormField(
            key: _isWordLearnedStateKey,
            initialValue: widget.word.isLearned,
          ),
        ],
      ),
    );
  }
  
  Widget _buildWordFormField() {
    return PaddingWrapper(
      child: WithoutErrorTextFormField(
        key: _wordStateKey,
        initialValue: widget.word.word,
        validator: (value) => value?.isEmpty ?? true ? '' : null,
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
        decoration: InputDecoration(hintText: _locale.writeAssociationOrHint),
      ),
    );
  }

  Widget _buildEditWordButton() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: ElevatedButton(
          child: Text(_locale.edit),
          onPressed: _isFromValid ? _onEdit : null,
        ),
      ),
    );
  }

  Future<void> _onEdit() async {
    final editedWord = widget.word.copyWith(
      word: _wordStateKey.currentState?.value,
      translations: _listStateKey.currentState?.value,
      hint: _hintStateKey.currentState?.value,
      isLearned: _isWordLearnedStateKey.currentState?.value,
    );

    if(widget.word != editedWord) {
      Navigator.pop<Word>(context, editedWord);
    } else {
      Navigator.pop(context);
    }
  }
}
