import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mydictionaryapp/src/app/screens/auth_screens/login_screen.dart';
import 'package:mydictionaryapp/src/app/screens/dictionaries_screen/dictionaries_screen_presenter.dart';
import 'package:mydictionaryapp/src/app/screens/new_dictionary_screen/new_dictionary_screen.dart';
import 'package:mydictionaryapp/src/app/screens/words_screen/words_screen.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_indicator.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/app/utils/dialog_builder.dart';
import 'package:mydictionaryapp/src/app/utils/show_snack_bar.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';

//TODO: remove the import
import 'package:mydictionaryapp/src/device/utils/localization.dart';

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
      create: (context) => DictionariesScreenPresenter(),
      child: DictionariesScreen(),
    );
  }

  @override
  _DictionariesScreenState createState() => _DictionariesScreenState();
}

class _DictionariesScreenState extends State<DictionariesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

    if (position.pixels >= position.maxScrollExtent * 0.8) {
      await _read.uploadNewDictionaries();
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
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final title = Text(userDictionaries);

    if (_isIOS) {
      return CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: title,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.add_circled_solid),
          onPressed: _onAddNewDictionaryPressed,
        ),
      );
    }
    return AppBar(
      automaticallyImplyLeading: false,
      title: title,
    );
  }

  Widget _buildBody() {
    if (_watch.dictionaries == null) {
      return LoadingIndicator();
    }

    if (_watch.dictionaries.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(listEmptyInfo, textAlign: TextAlign.center),
      );
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
                onPressed: _onItemPressed,
                onEdit: _onItemEdit,
              );
            },
            childCount: dictionaries.length,
          ),
        ),
        if (_watch.isNewDictionariesLoading)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 96.0,
              child: LoadingIndicator(),
            ),
          ),
      ],
    );
  }

  Future<void> _onItemPressed(Dictionary dictionary) async {
    await Navigator.of(context).push(WordsScreen.buildPageRoute(dictionary));
  }

  Future<void> _onItemEdit(Dictionary dictionary) async {
    //TODO: edit dictionary
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: _onAddNewDictionaryPressed,
    );
  }

  Future<void> _onAddNewDictionaryPressed() async {
    final newDictionary = await Navigator.of(context).push(
      NewDictionaryScreen.buildPageRoute(),
    );
    if (newDictionary != null) {
      //TODO: create new dictionary
    }
  }

  Widget _buildBottomNavigationBar() {
    final title = Text(changeUser);

    if (_isIOS) {
      return SafeArea(
        child: CupertinoButton(
          child: title,
          onPressed: _showDialogOnLogout,
        ),
      );
    }

    return SafeArea(
      child: Material(
        elevation: 8.0,
        child: InkWell(
          child: Container(
            height: 48.0,
            alignment: Alignment.center,
            child: title,
          ),
          onTap: _showDialogOnLogout,
        ),
      ),
    );
  }

  Future<void> _showDialogOnLogout() async {
    await showDialog(
      context: context,
      builder: dialogBuilder(context, askChangeUser, _onExit),
    );
  }

  Future<void> _onExit() async {
    try {
      Navigator.of(context).pop();
      await _read.changeUser();
      await Navigator.of(context).pushAndRemoveUntil(
        LoginScreen.buildPageRoute(),
        (route) => false,
      );
    } on LogOutException {
      showErrorMessage(_scaffoldKey, logOutException);
    } catch (e) {
      //TODO: handle errors
      showErrorMessage(_scaffoldKey, e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
