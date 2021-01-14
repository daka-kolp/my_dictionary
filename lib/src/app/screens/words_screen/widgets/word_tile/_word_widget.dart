part of 'word_tile.dart';

class _WordWidget extends StatelessWidget {
  final Word word;

  const _WordWidget({Key key, @required this.word})
      : assert(word != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: word.isHintExist
          ? () async => await showDialog(
                context: context,
                builder: _showHint,
              )
          : null,
      child: Container(
        height: 48.0,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(word.word),
      ),
    );
  }

  Widget _showHint(BuildContext context) {
    final contentText = Text(word.hint);
    final okText = Text(ok);

    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        content: contentText,
        actions: <Widget>[
          CupertinoDialogAction(
            child: okText,
            onPressed: () => _onOkPressed(context),
          )
        ],
      );
    }

    return AlertDialog(
      content: contentText,
      actions: <Widget>[
        FlatButton(
          child: okText,
          onPressed: () => _onOkPressed(context),
        ),
      ],
    );
  }

  void _onOkPressed(BuildContext context) => Navigator.pop(context);
}
