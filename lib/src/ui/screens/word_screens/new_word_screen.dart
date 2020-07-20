import 'dart:io';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/ui/screens/word_screens/widgets/padding_wrapper.dart';
import 'package:mydictionaryapp/src/ui/screens/word_screens/widgets/title_tile.dart';
import 'package:mydictionaryapp/src/ui/screens/word_screens/widgets/translations_list_form_field.dart';
import 'package:mydictionaryapp/src/ui/screens/word_screens/new_word_screen_presenter.dart';
import 'package:mydictionaryapp/src/ui/widgets/no_scroll_behavior.dart';
import 'package:mydictionaryapp/src/ui/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/ui/widgets/without_error_text_form_field.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/utils/localization/localization.dart';

class NewWordScreen extends StatefulWidget {
  static PageRoute buildPageRoute(Dictionary dictionary) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder(dictionary));
    }
    return MaterialPageRoute(builder: _builder(dictionary));
  }

  static WidgetBuilder _builder(Dictionary dictionary) {
    return (context) => ChangeNotifierProvider(
          create: (context) => NewWordScreenPresenter(dictionary),
          child: NewWordScreen(),
        );
  }

  @override
  _NewWordScreenState createState() => _NewWordScreenState();
}

class _NewWordScreenState extends State<NewWordScreen> {
  final _uuid = Uuid();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formStateKey = GlobalKey<FormState>();
  final _wordStateKey = GlobalKey<FormFieldState<String>>();
  final _listStateKey = GlobalKey<FormFieldState<List<Translation>>>();
  final _hintStateKey = GlobalKey<FormFieldState<String>>();

  bool _isFromValid = false;

  NewWordScreenPresenter get _watch => context.watch<NewWordScreenPresenter>();
  NewWordScreenPresenter get _read => context.read<NewWordScreenPresenter>();

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
    final title = Text(addNewWord);

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
              TitleTile(title: enterWord, isRequired: true),
              _buildWordFormField(),
              TitleTile(title: addTranslation, isRequired: true),
              _buildTranslationsListFormField(),
              TitleTile(title: addHint),
              _buildHintFormField(),
              _buildAddWordButton(),
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
        decoration: InputDecoration(
          hintText: writeAssociationOrHint,
        ),
      ),
    );
  }

  Widget _buildAddWordButton() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        height: 48.0,
        width: double.infinity,
        child: RaisedButton(
          child: Text(add),
          onPressed: _isFromValid ? _onAdd : null,
        ),
      ),
    );
  }

  Future<void> _onAdd() async {
    final newWord = Word(
      id: _uuid.v4(),
      word: _wordStateKey.currentState.value,
      translations: _listStateKey.currentState.value,
      hint: _hintStateKey.currentState.value,
      addingTime: DateTime.now(),
    );

    try {
      await _read.addWordToDictionary(newWord);
      Navigator.pop<Word>(context, newWord);
    } on WordAlreadyExistException {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(wordAlreadyExistException)),
      );
    }
  }
}
