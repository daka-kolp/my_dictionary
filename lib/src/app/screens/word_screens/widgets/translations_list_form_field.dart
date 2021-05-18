import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/word.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/device/utils/localization.dart';

part '_translation_list_tile.dart';

class TranslationListFormField extends FormField<List<Translation>> {
  TranslationListFormField({
    Key? key,
    List<Translation> initialList = const [],
    FormFieldSetter<List<Translation>>? onSaved,
  }) : super(
          key: key,
          initialValue: initialList,
          validator: (list) => list!.isEmpty ? '' : null,
          builder: (field) {
            return _TranslationList(
              initialList: initialList,
              onChanged: field.didChange,
            );
          },
        );
}

class _TranslationList extends StatefulWidget {
  final List<Translation> initialList;
  final ValueChanged<List<Translation>?> onChanged;

  const _TranslationList({
    Key? key,
    required this.initialList,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TranslationListState createState() => _TranslationListState();
}

class _TranslationListState extends State<_TranslationList> {
  final _translationController = TextEditingController();

  List<Translation>? _translationsList;
  bool _textNotEmpty = false;

  @override
  void initState() {
    super.initState();
    _translationsList = widget.initialList.toList();
    _translationController.addListener(_controllerListener);
  }

  void _controllerListener() {
    setState(() {
      _textNotEmpty = _translationController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildNewTranslationField(),
        _buildTranslationsList(),
      ],
    );
  }

  Widget _buildNewTranslationField() {
    return TextField(
      controller: _translationController,
      onSubmitted: _textNotEmpty ? (value) => _onAdd() : null,
      decoration: InputDecoration(
        hintText: writeTranslation,
        suffixIcon: IconButton(
          icon: Icon(Icons.add),
          onPressed: _textNotEmpty ? _onAdd : null,
        ),
      ),
    );
  }

  void _onAdd() {
    setState(() {
      _translationsList!.add(
        Translation.newInstance(
          translation: _translationController.text,
        ),
      );
      _translationController.clear();
    });
    widget.onChanged(_translationsList);
  }

  Widget _buildTranslationsList() {
    return _translationsList!.isNotEmpty
        ? ListView(
            padding: const EdgeInsets.only(top: 8.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children:
                _translationsList!.reversed.map(_buildTranslationTile).toList(),
          )
        : Container();
  }

  Widget _buildTranslationTile(Translation translation) {
    return _TranslationListTile(
      key: Key(translation.id),
      translation: translation,
      onRemove: _onRemove,
    );
  }

  void _onRemove(Translation data) {
    setState(() => _translationsList!.remove(data));
    widget.onChanged(_translationsList);
  }

  @override
  void dispose() {
    _translationController.dispose();
    super.dispose();
  }
}
