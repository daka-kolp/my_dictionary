part of '../dictionaries_screen.dart';

class _DictionaryTile extends StatelessWidget {
  final Dictionary dictionary;
  final bool isEven;
  final VoidCallback onPressed;

  const _DictionaryTile({
    Key key,
    @required this.dictionary,
    @required this.isEven,
    @required this.onPressed,
  })  : assert(dictionary != null),
        assert(isEven != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _getTileColor(Theme.of(context)),
      child: ListTile(
        title: Text(dictionary.title),
        onTap: onPressed,
      ),
    );
  }

  Color _getTileColor(ThemeData theme) {
    return isEven
        ? theme.accentColor.withOpacity(0.3)
        : theme.scaffoldBackgroundColor;
  }
}
