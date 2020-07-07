import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/device/utils/global_config.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/ui/screens/dictionary_screen/dictionary_screen.dart';
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
        theme: GetIt.I.get<GlobalConfig>().theme,
        home: DictionaryScreen(dictionary: _dictionary),
      ),
    );
  }

  Dictionary get _dictionary {
    final tags = {
      'new': Tag(
        id: '1',
        color: Colors.red,
        tag: 'New',
      ),
      'noun': Tag(
        id: '2',
        color: Colors.green,
        tag: 'Noun',
      ),
      'verb': Tag(
        id: '3',
        color: Colors.blue,
        tag: 'Verb',
      ),
      'learned': Tag(
        id: '4',
        color: Colors.lime,
        tag: 'Learned',
      ),
      'lost series': Tag(
        id: '5',
        color: Colors.indigo,
        tag: 'Lost series',
      ),
    };
    return Dictionary(
      id: '111',
      originalLanguage: 'en',
      translationLanguage: 'ru',
      title: 'English',
      words: [
        Word(
          id: '11',
          word: 'name',
          translations: [
            Translation(
              id: '1',
              translation: 'имя',
            ),
            Translation(
              id: '2',
              translation: 'название',
            ),
          ],
          hint: 'Дается при родждении',
          tags: [
            tags['new'],
            tags['noun'],
          ],
        ),
        Word(
          id: '22',
          word: 'dog',
          translations: [
            Translation(
              id: '1',
              translation: 'собака',
            ),
            Translation(
              id: '2',
              translation: 'пёс',
            ),
          ],
          hint: 'Домашнее гавкающее животное',
        ),
        Word(
          id: '33',
          word: 'home',
          translations: [
            Translation(
              id: '1',
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
          id: '44',
          word: 'word',
          translations: [
            Translation(
              id: '1',
              translation: 'слово',
            )
          ],
        ),
        Word(
          id: '55',
          word: 'to admit',
          tags: [
            tags['new'],
            tags['verb'],
          ],
        ),
        Word(
          id: '66',
          word: 'to embarrass',
          translations: [
            Translation(
              id: '1',
              translation: 'смущать',
            )
          ],
        ),
        Word(
          id: '77',
          word: 'flabbergasted',
          translations: [
            Translation(
              id: '1',
              translation: 'ошеломлен',
            )
          ],
        ),
        Word(
          id: '88',
          word: 'to discombobulated',
          translations: [
            Translation(
              id: '1',
              translation: 'ходить кругами',
            )
          ],
        ),
      ],
    );
  }
}
