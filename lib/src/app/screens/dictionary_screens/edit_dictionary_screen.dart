import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/app/screens/word_screens/widgets/padding_wrapper.dart';
import 'package:mydictionaryapp/src/app/screens/word_screens/widgets/title_tile.dart';
import 'package:mydictionaryapp/src/app/utils/no_scroll_behavior.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/app/widgets/without_error_text_form_field.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/device/utils/localization.dart';

class EditDictionaryScreen extends StatefulWidget {
  final Dictionary dictionary;

  const EditDictionaryScreen({Key key, @required this.dictionary})
      : assert(dictionary != null),
        super(key: key);

  static PageRoute buildPageRoute(Dictionary dictionary) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder(dictionary));
    }
    return MaterialPageRoute(builder: _builder(dictionary));
  }

  static WidgetBuilder _builder(Dictionary dictionary) {
    return (context) => EditDictionaryScreen(dictionary: dictionary);
  }

  @override
  _EditDictionaryScreenState createState() => _EditDictionaryScreenState();
}

class _EditDictionaryScreenState extends State<EditDictionaryScreen> {
  final _formStateKey = GlobalKey<FormState>();
  final _dictionaryNameStateKey = GlobalKey<FormFieldState<String>>();

  bool _isFromValid = false;

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
          onPressed: () {},
        ),
      );
    }

    return AppBar(
      title: title,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: remove,
          onPressed: () {},
        ),
      ],
    );
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
                  TitleTile(title: editDictionaryName),
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
    setState(() => _isFromValid = _formStateKey.currentState.validate());
  }

  Widget _buildDictionaryNameFormField() {
    return PaddingWrapper(
      child: WithoutErrorTextFormField(
        key: _dictionaryNameStateKey,
        initialValue: widget.dictionary.title,
        validator: (value) => value.isEmpty || value.compareTo(widget.dictionary.title) == 0 ? '' : null,
      ),
    );
  }

  Widget _buildEditDictionaryButton() {
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
    final editDictionary = widget.dictionary.copyWith(
      title: _dictionaryNameStateKey.currentState.value,
    );
    Navigator.pop<Dictionary>(context, editDictionary);
  }
}
