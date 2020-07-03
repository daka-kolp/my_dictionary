import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/ui/dictionary_screen/dictionary_screen.dart';
import 'package:mydictionaryapp/src/ui/widgets/environment_banner.dart';

void runMyDictionaryApp() {
  runApp(MyDictionaryApp());
}

class MyDictionaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EnvironmentBanner(
      child: MaterialApp(
        title: 'MyDictionary',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DictionaryScreen(dictionary: _dictionary),
      ),
    );
  }

  final _dictionary = Dictionary(
    title: 'English',
    words: [
      Word(
        word: 'name',
        translations: [
          Translation(translation: 'имя'),
          Translation(translation: 'название'),
        ],
        hint: 'Дается при родждении',
      ),
      Word(
        word: 'dog',
        translations: [
          Translation(translation: 'собака'),
          Translation(translation: 'пес'),
        ],
        hint: 'Домашнее гавкающее животное',
      ),
      Word(
        word: 'home',
        translations: [
          Translation(
            translation: 'дом',
          )
        ],
      ),
      Word(
        word: 'word',
        translations: [
          Translation(
            translation: 'слово',
          )
        ],
      ),
      Word(
        word: 'to admit',
      ),
    ],
  );
}
