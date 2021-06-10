import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/my_dictionary_localization.dart';
import 'package:provider/provider.dart';

import 'package:mydictionaryapp/src/app/pages/word_pages/edit_word_page.dart';
import 'package:mydictionaryapp/src/app/pages/word_pages/new_word_page.dart';
import 'package:mydictionaryapp/src/app/pages/words_page/words_page_presenter.dart';
import 'package:mydictionaryapp/src/app/pages/words_page/widgets/tts_provider.dart';
import 'package:mydictionaryapp/src/app/pages/words_page/widgets/word_tile/word_tile.dart';
import 'package:mydictionaryapp/src/app/utils/show_snack_bar.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_indicator.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';

class WordsPage extends Page {
  final Dictionary dictionary;

  const WordsPage(this.dictionary);
  @override
  Route createRoute(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder);
    }
    return MaterialPageRoute(builder: _builder);
  }

  Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WordsPagePresenter(dictionary),
      child: _WordsScreen(),
    );
  }
}

class _WordsScreen extends StatefulWidget {
  @override
  _WordsScreenState createState() => _WordsScreenState();
}

class _WordsScreenState extends State<_WordsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = ScrollController();

  bool get _isIOS => Platform.isIOS;

  MyDictionaryLocalizations get _locale => MyDictionaryLocalizations.of(context)!;
  WordsPagePresenter get _watch => context.watch<WordsPagePresenter>();
  WordsPagePresenter get _read => context.read<WordsPagePresenter>();

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
        key: _scaffoldKey,
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
    if (_watch.isInit) {
      return LoadingIndicator();
    }

    if (_watch.words.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(_locale.listEmptyInfo, textAlign: TextAlign.center),
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
      EditWordPage(word).createRoute(context),
    );

    if (returnedValue != null) {
      try {
        if (returnedValue.runtimeType == String) {
          await _read.removeWord(returnedValue);
        } else if (returnedValue.runtimeType == Word) {
          await _read.updateWord(returnedValue);
        }
      } on WordNotExistException {
        showErrorMessage(context, _locale.wordNotExistException);
      } catch (e) {
        //TODO: handle errors
        showErrorMessage(context, e.toString());
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
      NewWordPage().createRoute(context),
    );

    if (returnedValue != null && returnedValue.runtimeType == Word) {
      try {
        await _read.addNewWord(returnedValue);
      } on WordAlreadyExistException {
        showErrorMessage(context, _locale.wordAlreadyExistException);
      } catch (e) {
        //TODO: handle errors
        showErrorMessage(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
