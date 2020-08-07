import 'package:flutter/material.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';

class WordTilePresenter extends ChangeNotifier {
  Word _word;

  WordTilePresenter(Word word) : _word = word;

  Future<void> onUpdate(Word word) async {

  }

  Future<void> onRemove() async {

  }
}
