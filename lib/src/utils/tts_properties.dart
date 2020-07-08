import 'dart:io';

class TtsProperties {
  final String language;
  final speechRate = Platform.isIOS ? 0.5 : 1.0; //speech speed
  final volume = 1.0;
  final pitch = 1.0; //voice tone

  TtsProperties(this.language);
}
