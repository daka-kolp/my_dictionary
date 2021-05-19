part of 'word_tile.dart';

class _WordWidget extends StatelessWidget {
  final Word word;

  const _WordWidget({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: word.isHintExist ? () async => await _showDialog(context) : null,
      child: Container(
        height: 48.0,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(word.word),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: dialogBuilder(
        context,
        word.hint,
        () => Navigator.pop(context),
        isCancelButtonExist: false,
      ),
    );
  }
}
