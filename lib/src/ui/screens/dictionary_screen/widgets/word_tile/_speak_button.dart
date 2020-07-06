part of 'word_tile.dart';

class _SpeakButton extends StatelessWidget {
  final Word word;
  final FlutterTtsImproved tts;

  const _SpeakButton({
    Key key,
    @required this.word,
    @required this.tts,
  })  : assert(word != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: listen,
      icon: Icon(Icons.volume_up),
      onPressed: () async => await tts.speak(word.word),
    );
  }
}
