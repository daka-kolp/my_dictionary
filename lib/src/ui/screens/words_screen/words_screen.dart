import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/ui/widgets/loading_widget.dart';
import 'package:mydictionaryapp/src/ui/screens/word_screens/edit_word_screen.dart';
import 'package:mydictionaryapp/src/ui/screens/word_screens/new_word_screen.dart';
import 'package:mydictionaryapp/src/ui/screens/words_screen/words_screen_presenter.dart';
import 'package:mydictionaryapp/src/ui/screens/words_screen/widgets/tts_provider.dart';
import 'package:mydictionaryapp/src/ui/screens/words_screen/widgets/word_tile/word_tile.dart';
import 'package:mydictionaryapp/src/utils/dimens.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/utils/localization/localization.dart';

class WordsScreen extends StatefulWidget {
  static PageRoute buildPageRoute(Dictionary dictionary) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder(dictionary));
    }
    return MaterialPageRoute(builder: _builder(dictionary));
  }

  static WidgetBuilder _builder(Dictionary dictionary) {
    return (context) => ChangeNotifierProvider(
          create: (context) => WordsScreenPresenter(context, dictionary),
          child: WordsScreen(),
        );
  }

  @override
  _WordsScreenState createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> {
  final _controller = ScrollController();

  bool get _isIOS => Platform.isIOS;

  WordsScreenPresenter get _watch => context.watch<WordsScreenPresenter>();
  WordsScreenPresenter get _read => context.read<WordsScreenPresenter>();

  FlutterTts _tts;

  @override
  void initState() {
    super.initState();
    _initTts();
    _controller.addListener(_scrollListener);
  }

  Future<void> _scrollListener() async {
    final position = _controller.position;

    if (position.pixels == position.maxScrollExtent * 0.8) {
      await _read.uploadNewWords();
    }
  }

  Future<void> _initTts() async {
    final ttsProp = _read.dictionary.ttsProperties;
    _tts = FlutterTts();

    await Future.wait([
      _tts.setLanguage(ttsProp.language),
      _tts.setSpeechRate(ttsProp.speechRate),
      _tts.setVolume(ttsProp.volume),
      _tts.setPitch(ttsProp.pitch),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _isIOS ? null : _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final title = Text(_watch.dictionary.title);

    if (_isIOS) {
      return CupertinoNavigationBar(
        middle: title,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(add),
          onPressed: _onAddNewWordPressed,
        ),
      );
    }
    return AppBar(title: title);
  }

  Widget _buildBody() {
    if (_watch.isLoading) {
      return LoadingWidget();
    }

    final words = _watch.words;
    return TtsProvider(
      tts: _tts,
      child: CustomScrollView(
        controller: _controller,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return WordTile(
                  isEven: (index + 1).isEven,
                  word: words[index],
                  onEdit: () => _onEditWordPressed(words[index]),
                );
              },
              childCount: words.length,
            ),
          ),
          if (_watch.isNewWordsLoading)
            SliverToBoxAdapter(
              child: SizedBox(
                height: loadingWidgetHeight,
                child: LoadingWidget(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onEditWordPressed(Word word) async {
    final returnedValue = await Navigator.of(context).push(
      EditWordScreen.buildPageRoute(_read.dictionary, word),
    );

    if (returnedValue != null) {
      if (returnedValue.runtimeType == String) {
        _read.removeWord(returnedValue);
      } else {
        _read.updateWord(returnedValue);
      }
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: _onAddNewWordPressed,
    );
  }

  Future<void> _onAddNewWordPressed() async {
    final newWord = await Navigator.of(context).push(
      NewWordScreen.buildPageRoute(_read.dictionary),
    );

    if (newWord != null) {
      _read.insertNewWord(newWord);
    }
  }

  @override
  void dispose() {
    _tts.stop();
    _controller.dispose();
    super.dispose();
  }
}
