part of '../main_page.dart';

typedef DictionaryCallback = Future<void> Function(Dictionary dictionary);

class _DictionaryTile extends StatelessWidget {
  final Dictionary dictionary;
  final bool isEven;
  final DictionaryCallback onPressed;
  final DictionaryCallback onEdit;

  const _DictionaryTile({
    Key? key,
    required this.dictionary,
    required this.isEven,
    required this.onPressed,
    required this.onEdit,
  }) : super(key: key);

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
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          tooltip: MyDictionaryLocalizations.of(context)!.edit,
          icon: Icon(Icons.edit),
          onPressed: () async => await onEdit(dictionary),
        );
      },
    );
  }
}

class _DictionaryWidget extends StatelessWidget {
  final Dictionary dictionary;
  final DictionaryCallback onPressed;

  const _DictionaryWidget({
    Key? key,
    required this.dictionary,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => await onPressed(dictionary),
      child: Container(
        height: 56.0,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          dictionary.title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}
