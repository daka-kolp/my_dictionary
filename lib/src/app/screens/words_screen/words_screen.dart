import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mydictionaryapp/src/app/screens/word_screens/edit_word_screen.dart';
import 'package:mydictionaryapp/src/app/screens/word_screens/new_word_screen.dart';
import 'package:mydictionaryapp/src/app/screens/words_screen/words_screen_presenter.dart';
import 'package:mydictionaryapp/src/app/screens/words_screen/widgets/tts_provider.dart';
import 'package:mydictionaryapp/src/app/screens/words_screen/widgets/word_tile/word_tile.dart';
import 'package:mydictionaryapp/src/app/utils/show_snack_bar.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_indicator.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/device/utils/localization.dart';

class WordsScreen extends StatefulWidget {
  static PageRoute buildPageRoute(Dictionary dictionary) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder(dictionary));
    }
    return MaterialPageRoute(builder: _builder(dictionary));
  }

  static WidgetBuilder _builder(Dictionary dictionary) {
    return (context) => ChangeNotifierProvider(
          create: (context) => WordsScreenPresenter(dictionary),
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

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  Future<void> _scrollListener() async {
    final position = _controller.position;

    if (position.pixels >= position.maxScrollExtent * 0.8) {
      await _read.uploadNewWords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingLayout(
      isLoading: _watch.isLoading,
      child: Scaffold(
        // key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _isIOS ? null : _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final title = Text(_watch.dictionary.title);

    if (_isIOS) {
      return CupertinoNavigationBar(
        middle: title,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.add_circled_solid),
          onPressed: _onAddNewWordPressed,
        ),
      );
    }
    return AppBar(title: title);
  }

  Widget _buildBody() {
    if (_watch.words.isEmpty) {
      return LoadingIndicator();
    }

    if (_watch.words.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(listEmptyInfo, textAlign: TextAlign.center),
      );
    }

    final words = _watch.words;
    return TtsProvider(
      tts: _watch.tts,
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
                height: 96.0,
                child: LoadingIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onEditWordPressed(Word word) async {
    final returnedValue = await Navigator.of(context).push(
      EditWordScreen.buildPageRoute(word),
    );

    if (returnedValue != null) {
      try {
        if (returnedValue.runtimeType == String) {
          await _read.removeWord(returnedValue);
        } else if (returnedValue.runtimeType == Word) {
          await _read.updateWord(returnedValue);
        }
      } on WordNotExistException {
        showErrorMessage(context, wordNotExistException);
      } catch (e) {
        //TODO: handle errors
        showErrorMessage(context, e);
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
    final returnedValue = await Navigator.of(context).push(
      NewWordScreen.buildPageRoute(),
    );

    if (returnedValue != null && returnedValue.runtimeType == Word) {
      try {
        await _read.addNewWord(returnedValue);
      } on WordAlreadyExistException {
        showErrorMessage(context, wordAlreadyExistException);
      } catch (e) {
        //TODO: handle errors
        showErrorMessage(context, e);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
