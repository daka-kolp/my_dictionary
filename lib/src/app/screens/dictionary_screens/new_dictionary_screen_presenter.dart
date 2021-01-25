import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NewDictionaryScreenPresenter with ChangeNotifier {
  final FlutterTts _tts;

  NewDictionaryScreenPresenter() : _tts = FlutterTts() {
    _init();
  }

  Future<void> _init() async {}

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}
