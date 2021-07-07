import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/my_dictionary_localization.dart';

import 'package:mydictionaryapp/src/app/pages/word_pages/widgets/padding_wrapper.dart';
import 'package:mydictionaryapp/src/app/pages/word_pages/widgets/title_tile.dart';
import 'package:mydictionaryapp/src/app/utils/dialog_builder.dart';
import 'package:mydictionaryapp/src/app/utils/no_scroll_behavior.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/app/widgets/switch_form_field.dart';
import 'package:mydictionaryapp/src/app/widgets/without_error_text_form_field.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';

class EditDictionaryPage extends Page {
  final Dictionary dictionary;

  const EditDictionaryPage(this.dictionary);

  @override
  Route createRoute(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder);
    }
    return MaterialPageRoute(builder: _builder);
  }

  Widget _builder(BuildContext context) {
    return _EditDictionaryScreen(dictionary: dictionary);
  }
}

class _EditDictionaryScreen extends StatefulWidget {
  final Dictionary dictionary;

  const _EditDictionaryScreen({Key? key, required this.dictionary})
      : super(key: key);

  @override
  _EditDictionaryScreenState createState() => _EditDictionaryScreenState();
}

class _EditDictionaryScreenState extends State<_EditDictionaryScreen> {
  final _formStateKey = GlobalKey<FormState>();
  final _isDictionaryMainStateKey = GlobalKey<FormFieldState<bool>>();
  final _dictionaryNameStateKey = GlobalKey<FormFieldState<String>>();

  bool _isFromValid = false;

  MyDictionaryLocalizations get _locale => MyDictionaryLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  void _resetFocusNode() => FocusScope.of(context).requestFocus(FocusNode());

  PreferredSizeWidget _buildAppBar() {
    final title = Text(widget.dictionary.title);

    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: title,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.delete_simple),
          onPressed: _showDialogOnRemoveDictionary,
        ),
      );
    }

    return AppBar(
      title: title,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: _locale.remove,
          onPressed: _showDialogOnRemoveDictionary,
        ),
      ],
    );
  }

  Future<void> _showDialogOnRemoveDictionary() async {
    await showDialog(
      context: context,
      builder: dialogBuilder(context, _locale.removeDictionaryQuestion, _onRemove),
    );
  }

  void _onRemove() {
    Navigator.of(context)..pop()..pop<String>(widget.dictionary.id);
  }

  Widget _buildBody() {
    return LoadingLayout(
      isLoading: false,
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
                  _buildDictionaryIsMainSwitch(),
                  TitleTile(title: _locale.editDictionaryName),
                  _buildDictionaryNameFormField(),
                  _buildEditDictionaryButton(),
                ],
              ),
            ),
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

  Widget _buildDictionaryIsMainSwitch() {
    return PaddingWrapper(
      child: Row(
        children: [
          Expanded(
            child: Text(
              _locale.isDictionaryMain,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          SwitchFormField(
            key: _isDictionaryMainStateKey,
            initialValue: widget.dictionary.isMain,
          ),
        ],
      ),
    );
  }

  Widget _buildDictionaryNameFormField() {
    return PaddingWrapper(
      child: WithoutErrorTextFormField(
        key: _dictionaryNameStateKey,
        initialValue: widget.dictionary.title,
        validator: (value) => value?.isEmpty ?? true ? '' : null,
      ),
    );
  }

  Widget _buildEditDictionaryButton() {
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
    final editDictionary = widget.dictionary.copyWith(
      title: _dictionaryNameStateKey.currentState?.value,
      isMain: _isDictionaryMainStateKey.currentState?.value
    );
    if (_isDictionariesEqual(widget.dictionary, editDictionary)) {
      Navigator.pop(context);
    } else {
      Navigator.pop<Dictionary>(context, editDictionary);
    }
  }

  bool _isDictionariesEqual(Dictionary d1, Dictionary d2) =>
      d1.title == d2.title && d1.isMain == d2.isMain;
}
