part of '../dictionaries_screen.dart';

typedef DictionaryCallback = Future<void> Function(Dictionary dictionary);

class _DictionaryTile extends StatelessWidget {
  final Dictionary dictionary;
  final bool isEven;
  final DictionaryCallback onPressed;
  final DictionaryCallback onEdit;

  const _DictionaryTile({
    Key key,
    @required this.dictionary,
    @required this.isEven,
    @required this.onPressed,
    @required this.onEdit,
  })  : assert(dictionary != null),
        assert(isEven != null),
        assert(onPressed != null),
        assert(onEdit != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _getTileColor(Theme.of(context)),
      child: Padding(
        padding: const EdgeInsets.all(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: _DictionaryWidget(
                dictionary: dictionary,
                onPressed: onPressed,
              ),
            ),
            _buildEditButton(),
          ],
        ),
      ),
    );
  }

  Color _getTileColor(ThemeData theme) {
    return isEven
        ? theme.accentColor.withOpacity(0.3)
        : theme.scaffoldBackgroundColor;
  }

  Widget _buildEditButton() {
    return IconButton(
      tooltip: edit,
      icon: Icon(Icons.edit),
      onPressed: () async => await onEdit(dictionary),
    );
  }
}

class _DictionaryWidget extends StatelessWidget {
  final Dictionary dictionary;
  final DictionaryCallback onPressed;

  const _DictionaryWidget({
    Key key,
    @required this.dictionary,
    @required this.onPressed,
  })  : assert(dictionary != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async => await onPressed(dictionary),
      child: Container(
        height: dictionaryTileHeight,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          dictionary.title,
          style: theme.textTheme.subtitle1,
        ),
      ),
    );
  }
}
