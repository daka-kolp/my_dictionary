import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/ui/screens/dictionaries_screen/dictionaries_screen_presenter.dart';
import 'package:mydictionaryapp/src/ui/screens/words_screen/words_screen.dart';
import 'package:mydictionaryapp/src/ui/widgets/loading_widget.dart';
import 'package:mydictionaryapp/src/utils/dimens.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/utils/localization/localization.dart';

part 'widgets/_dictionary_tile.dart';

class DictionariesScreen extends StatefulWidget {
  static PageRoute buildPageRoute() {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder);
    }
    return MaterialPageRoute(builder: _builder);
  }

  static Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DictionariesScreenPresenter(context),
      child: DictionariesScreen(),
    );
  }

  @override
  _DictionariesScreenState createState() => _DictionariesScreenState();
}

class _DictionariesScreenState extends State<DictionariesScreen> {
  final _controller = ScrollController();

  bool get _isIOS => Platform.isIOS;
  DictionariesScreenPresenter get _watch =>
      context.watch<DictionariesScreenPresenter>();
  DictionariesScreenPresenter get _read =>
      context.read<DictionariesScreenPresenter>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  Future<void> _scrollListener() async {
    final position = _controller.position;

    if (position.pixels == position.maxScrollExtent * 0.8) {
      await _read.uploadNewDictionaries();
    }
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
    final title = Text(userDictionaries);

    if (_isIOS) {
      return CupertinoNavigationBar(
        middle: title,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(add),
          onPressed: _onAddNewDictionaryPressed,
        ),
      );
    }
    return AppBar(title: title);
  }

  Widget _buildBody() {
    if (_watch.isLoading) {
      return LoadingWidget();
    }

    final dictionaries = _watch.dictionaries;
    return CustomScrollView(
      controller: _controller,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final dictionary = dictionaries[index];
              return _DictionaryTile(
                isEven: (index + 1).isEven,
                dictionary: dictionary,
                onPressed: () async => await _onItemPressed(dictionary),
              );
            },
            childCount: dictionaries.length,
          ),
        ),
        if (_watch.isNewDictionariesLoading)
          SliverToBoxAdapter(
            child: SizedBox(
              height: loadingWidgetHeight,
              child: LoadingWidget(),
            ),
          ),
      ],
    );
  }

  Future<void> _onItemPressed(Dictionary dictionary) async {
    await Navigator.of(context).push(WordsScreen.buildPageRoute(dictionary));
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: _onAddNewDictionaryPressed,
    );
  }

  Future<void> _onAddNewDictionaryPressed() async {
    //TODO: add new dictionary
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
