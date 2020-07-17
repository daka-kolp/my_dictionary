import 'dart:io';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/ui/screens/new_word_screen/widgets/translations_list_form_field.dart';
import 'package:mydictionaryapp/src/ui/screens/new_word_screen/new_word_screen_presenter.dart';
import 'package:mydictionaryapp/src/ui/widgets/no_scroll_behavior.dart';
import 'package:mydictionaryapp/src/ui/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/ui/widgets/without_error_text_form_field.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/utils/localization/localization.dart';

part 'widgets/_title_tile.dart';
part 'widgets/_padding_wrapper.dart';

class NewWordScreen extends StatefulWidget {
  static PageRoute<Word> buildPageRoute(Dictionary dictionary) {
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
        child: Form(
          key: _formStateKey,
          onChanged: _onFormChange,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: _buildAppBar(),
            body: _buildBody(),
          ),
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
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(ok),
          onPressed: _isFromValid ? _onAdd : null,
        ),
      );
    }
    return AppBar(
      title: title,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          tooltip: ok,
          onPressed: _isFromValid ? _onAdd : null,
        ),
      ],
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
      ),
    );
  }

  String _validateTextFormField(String value) {
    if (value.isEmpty) return '';
    return null;
  }

  Widget _buildTranslationsListFormField() {
    return _PaddingWrapper(
      child: TranslationListFormField(
        key: _listStateKey,
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
      ),
    );
  }
}
