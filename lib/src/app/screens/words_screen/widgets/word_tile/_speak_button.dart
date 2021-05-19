part of 'word_tile.dart';

class _SpeakButton extends StatelessWidget {
  final Word word;

  const _SpeakButton({
    Key? key,
    required this.word,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: listen,
      icon: Icon(Icons.volume_up),
      onPressed: () => _onSpeak(context),
    );
  }

  Future<void> _onSpeak(BuildContext context) async {
    final tts = TtsProvider.of(context).tts;
    await tts.speak(word.word);
  }
}
