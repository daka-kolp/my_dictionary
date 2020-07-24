import 'dart:io';

import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/ui/widgets/no_scroll_behavior.dart';
import 'package:mydictionaryapp/src/ui/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/ui/widgets/without_error_text_form_field.dart';
import 'package:mydictionaryapp/src/ui/screens/word_screens/edit_word_screen_presenter.dart';
import 'package:mydictionaryapp/src/ui/screens/word_screens/widgets/padding_wrapper.dart';
import 'package:mydictionaryapp/src/ui/screens/word_screens/widgets/title_tile.dart';
import 'package:mydictionaryapp/src/ui/screens/word_screens/widgets/translations_list_form_field.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/utils/localization/localization.dart';

class EditWordScreen extends StatefulWidget {
  static PageRoute buildPageRoute(Dictionary dictionary, Word word) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder(dictionary, word));
    }
    return MaterialPageRoute(builder: _builder(dictionary, word));
  }

  static WidgetBuilder _builder(Dictionary dictionary, Word word) {
    return (context) => ChangeNotifierProvider(
          create: (context) => EditWordScreenPresenter(dictionary, word),
          child: EditWordScreen(),
        );
  }

  @override
  _EditWordScreenState createState() => _EditWordScreenState();
}

class _EditWordScreenState extends State<EditWordScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formStateKey = GlobalKey<FormState>();
  final _wordStateKey = GlobalKey<FormFieldState<String>>();
  final _listStateKey = GlobalKey<FormFieldState<List<Translation>>>();
  final _hintStateKey = GlobalKey<FormFieldState<String>>();

  bool _isFromValid = false;

  EditWordScreenPresenter get _watch => context.watch<EditWordScreenPresenter>();
  EditWordScreenPresenter get _read => context.read<EditWordScreenPresenter>();

  @override
  Widget build(BuildContext context) {
    return LoadingLayout(
      isLoading: _watch.isLoading,
      child: GestureDetector(
        onTap: _resetFocusNode,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(),
          body: _buildBody(),
        ),
      ),
    );
  }

  void _resetFocusNode() => FocusScope.of(context).requestFocus(FocusNode());

  PreferredSizeWidget _buildAppBar() {
    final title = Text(_watch.word.word);

    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: title,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(remove),
          onPressed: _onRemove,
        ),
      );
    }

    return AppBar(
      title: title,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: remove,
          onPressed: _onRemove,
        ),
      ],
    );
  }

  Future<void> _onRemove() async {
    try {
      await _read.removeWord();
      Navigator.pop<String>(context, _read.word.id);
    } on WordAlreadyExistException {
      _showErrorMessage(wordAlreadyExistException);
    }
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
        initialValue: _watch.word.word,
        validator: _validateTextFormField,
      ),
    );
  }

  String _validateTextFormField(String value) {
    if (value.isEmpty) return '';
    return null;
  }

  Widget _buildTranslationsListFormField() {
    return PaddingWrapper(
      child: TranslationListFormField(
        key: _listStateKey,
        initialList: _watch.word.translations,
      ),
    );
  }

  Widget _buildHintFormField() {
    return PaddingWrapper(
      child: TextFormField(
        key: _hintStateKey,
        initialValue: _watch.word.hint,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: writeAssociationOrHint,
        ),
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
    try {
      final newWord = _read.word.copyWith(
        word: _wordStateKey.currentState.value,
        translations: _listStateKey.currentState.value,
        hint: _hintStateKey.currentState.value,
      );
      await _read.editWord(newWord);
      Navigator.pop<Word>(context, newWord);
    } on WordNotExistException {
      _showErrorMessage(wordNotExistException);
    }
  }

  void _showErrorMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
