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

  Dictionary get _dictionary {
    final tags = {
      'new': Tag(
        color: Colors.red,
        tag: 'New',
      ),
      'noun': Tag(
        color: Colors.green,
        tag: 'Noun',
      ),
      'verb': Tag(
        color: Colors.blue,
        tag: 'Verb',
      ),
      'learned': Tag(
        color: Colors.lime,
        tag: 'Learned',
      ),
      'lost series': Tag(
        color: Colors.indigo,
        tag: 'Lost series',
      ),
    };
    return Dictionary(
      title: 'English',
      words: [
        Word(
          word: 'name',
          translations: [
            Translation(translation: 'имя'),
            Translation(translation: 'название'),
          ],
          hint: 'Дается при родждении',
          tags: [
            tags['new'],
            tags['noun'],
          ],
        ),
        Word(
          word: 'dog',
          translations: [
            Translation(translation: 'собака'),
            Translation(translation: 'пёс'),
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
          tags: [
            tags['new'],
            tags['noun'],
            tags['learned'],
            tags['lost series'],
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
          tags: [
            tags['new'],
            tags['verb'],
          ],
        ),
      ],
    );
  }
}
