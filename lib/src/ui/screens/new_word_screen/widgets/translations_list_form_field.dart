import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:mydictionaryapp/src/domain/entities/word.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/utils/localizations/localization.dart';

part '_translation_list_tile.dart';

class TranslationListFormField extends FormField<List<Translation>> {
  TranslationListFormField({
    Key key,
    @required FormFieldSetter<List<Translation>> onSaved,
  })  : assert(onSaved != null),
        super(
          key: key,
          initialValue: [],
          validator: (list) {
            if (list.isEmpty) return '';
            return null;
          },
          builder: (field) {
            return _TranslationList(
              onChanged: field.didChange,
            );
          },
        );
}

class _TranslationList extends StatefulWidget {
  final ValueChanged<List<Translation>> onChanged;

  const _TranslationList({
    Key key,
    @required this.onChanged,
  })  : assert(onChanged != null),
        super(key: key);

  @override
  _TranslationListState createState() => _TranslationListState();
}

class _TranslationListState extends State<_TranslationList> {
  final _uuid = Uuid();

  TextEditingController _translationController = TextEditingController();
  bool _translationIsNotEmpty = false;
  List<Translation> _translationsList = [];

  @override
  void initState() {
    super.initState();
    _translationController.addListener(_setTextFieldState);
  }

  void _setTextFieldState() {
    setState(() {
      _translationIsNotEmpty = _translationController.text.isNotEmpty;
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
      decoration: InputDecoration(
        hintText: writeTranslation,
        suffixIcon: IconButton(
          icon: Icon(Icons.add),
          onPressed: _translationIsNotEmpty ? _onAdd : null,
        ),
      ),
    );
  }

  void _onAdd() {
    setState(() {
      _translationsList.add(
        Translation(
          id: _uuid.v1(),
          translation: _translationController.text,
        ),
      );
      _translationController.clear();
    });
    widget.onChanged(_translationsList);
  }

  Widget _buildTranslationsList() {
    return _translationsList.isNotEmpty
        ? ListView(
            padding: const EdgeInsets.only(top: 8.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children:
                _translationsList.reversed.map(_buildTranslationTile).toList(),
          )
        : Container();
  }

  Widget _buildTranslationTile(Translation translation) {
    return _TranslationListTile(
      key: ValueKey(translation),
      translation: translation,
      onRemove: _onRemove,
    );
  }

  void _onRemove(Translation data) {
    setState(() => _translationsList.remove(data));
    widget.onChanged(_translationsList);
  }

  @override
  void dispose() {
    _translationController.dispose();
    super.dispose();
  }
}
