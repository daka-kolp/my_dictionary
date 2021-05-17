import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsProvider extends InheritedWidget {
  final FlutterTts tts;

  const TtsProvider({
    Key? key,
    required this.tts,
    required Widget child,
  }) : super(key: key, child: child);

  static TtsProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TtsProvider>();
  }

  @override
  bool updateShouldNotify(TtsProvider old) => tts != old.tts;
}
