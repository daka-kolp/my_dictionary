import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/ui/screens/dictionary_screen/dictionary_screen_presenter.dart';
import 'package:mydictionaryapp/src/ui/screens/dictionary_screen/widgets/tts_provider.dart';
import 'package:mydictionaryapp/src/ui/screens/dictionary_screen/widgets/word_tile/word_tile.dart';
import 'package:mydictionaryapp/src/ui/screens/new_word_screen/new_word_screen.dart';
import 'package:mydictionaryapp/src/ui/widgets/loading_widget.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/utils/localization/localization.dart';

class DictionaryScreen extends StatefulWidget {
  static PageRoute<DictionaryScreen> buildPageRoute(Dictionary dictionary) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder(dictionary));
    }
    return MaterialPageRoute(builder: _builder(dictionary));
  }

  static WidgetBuilder _builder(Dictionary dictionary) {
    return (context) => ChangeNotifierProvider(
          create: (context) => DictionaryScreenPresenter(dictionary),
          child: DictionaryScreen(),
        );
  }

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final _controller = ScrollController();

  bool get _isIOS => Platform.isIOS;

  DictionaryScreenPresenter get _watch =>
      context.watch<DictionaryScreenPresenter>();

  DictionaryScreenPresenter get _read =>
      context.read<DictionaryScreenPresenter>();

  FlutterTts _tts;

  @override
  void initState() {
    super.initState();
    _initTts();
    _controller.addListener(() async => await _scrollListener());
  }

  Future<void> _scrollListener() async {
    final position = _controller.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
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
                );
              },
              childCount: words.length,
            ),
          ),
          if (_watch.isLoading)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48.0,
                child: LoadingWidget(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: _onAddNewWordPressed,
    );
  }

  Future<void> _onAddNewWordPressed() async {
    await Navigator.of(context).push(
      NewWordScreen.buildPageRoute(_read.dictionary),
    );
    print(_watch.words);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}
