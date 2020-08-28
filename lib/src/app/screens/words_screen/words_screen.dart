import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import 'package:mydictionaryapp/src/app/screens/auth_screens/login_screen.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_indicator.dart';
import 'package:mydictionaryapp/src/app/screens/word_screens/edit_word_screen.dart';
import 'package:mydictionaryapp/src/app/screens/word_screens/new_word_screen.dart';
import 'package:mydictionaryapp/src/app/screens/words_screen/words_screen_presenter.dart';
import 'package:mydictionaryapp/src/app/screens/words_screen/widgets/tts_provider.dart';
import 'package:mydictionaryapp/src/app/screens/words_screen/widgets/word_tile/word_tile.dart';
import 'package:mydictionaryapp/src/app/utils/dimens.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/app/localization/localization.dart';

class WordsScreen extends StatefulWidget {
  static PageRoute buildPageRoute() {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder);
    }
    return MaterialPageRoute(builder: _builder);
  }

  static Widget _builder(context) {
    return ChangeNotifierProvider(
      create: (context) => WordsScreenPresenter(),
      child: WordsScreen(),
    );
  }

  @override
  _WordsScreenState createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

    if (position.pixels >= position.maxScrollExtent * 0.8) {
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
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _isIOS ? null : _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
    if (_watch.isLoading) {
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
                child: LoadingIndicator(),
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
    final returnedValue = await Navigator.of(context).push(
      NewWordScreen.buildPageRoute(),
    );

    if (returnedValue != null && returnedValue.runtimeType == Word) {
      try {
        await _read.insertNewWord(returnedValue);
      } on WordAlreadyExistException {
        _showErrorMessage(wordAlreadyExistException);
      }
    }
  }

  void _showErrorMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(message)),
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
        _showErrorMessage(wordAlreadyExistException);
      }
    }
  }


  Widget _buildBottomNavigationBar() {
    final title = Text(changeUser);

    if (_isIOS) {
      return CupertinoButton(
        child: title,
        onPressed: _onExit,
      );
    }

    return Material(
      elevation: 8.0,
      child: InkWell(
        child: Container(
          height: 48.0,
          alignment: Alignment.center,
          child: title,
        ),
        onTap: _showDialogOnLogout,
      ),
    );
  }



  Future<void> _showDialogOnLogout() async {
    await showDialog(
      context: context,
      builder: _buildDialogOnLogout,
    );
  }

  Widget _buildDialogOnLogout(BuildContext context) {
    final contentText = Text(askChangeUser);
    final okText = Text(ok);
    final cancelText = Text(cancel);

    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        content: contentText,
        actions: <Widget>[
          CupertinoDialogAction(
            child: cancelText,
            onPressed: Navigator.of(context).pop,
          ),
          CupertinoDialogAction(
            child: okText,
            onPressed: _onExit,
          )
        ],
      );
    }

    return AlertDialog(
      content: contentText,
      actions: <Widget>[
        FlatButton(
          child: cancelText,
          onPressed: Navigator.of(context).pop,
        ),
        FlatButton(
          child: okText,
          onPressed: _onExit,
        ),
      ],
    );
  }

  Future<void> _onExit() async {
    try {
      await _read.changeUser();
      await Navigator.of(context).pushAndRemoveUntil(
        LoginScreen.buildPageRoute(),
            (route) => false,
      );
    } on LogOutException {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(logOutException)),
      );
    }
  }


  @override
  void dispose() {
    _tts.stop();
    _controller.dispose();
    super.dispose();
  }
}
