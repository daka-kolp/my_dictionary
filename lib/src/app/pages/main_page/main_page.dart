import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/my_dictionary_localization.dart';
import 'package:provider/provider.dart';

import 'package:mydictionaryapp/src/app/pages/auth_pages/login_page.dart';
import 'package:mydictionaryapp/src/app/pages/main_page/main_page_presenter.dart';
import 'package:mydictionaryapp/src/app/pages/dictionary_pages/edit_dictionary_page.dart';
import 'package:mydictionaryapp/src/app/pages/dictionary_pages/new_dictionary_page.dart';
import 'package:mydictionaryapp/src/app/pages/words_page/words_page.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_indicator.dart';
import 'package:mydictionaryapp/src/app/widgets/loading_layout.dart';
import 'package:mydictionaryapp/src/app/utils/dialog_builder.dart';
import 'package:mydictionaryapp/src/app/utils/show_snack_bar.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';

part 'widgets/_dictionary_tile.dart';

class MainPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: _builder);
    }
    return MaterialPageRoute(builder: _builder);
  }

  Widget _builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainPagePresenter(),
      child: _MainScreen(),
    );
  }
}

class _MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<_MainScreen> {
  MyDictionaryLocalizations get _locale => MyDictionaryLocalizations.of(context)!;
  bool get _isIOS => Platform.isIOS;
  MainPagePresenter get _watch => context.watch<MainPagePresenter>();
  MainPagePresenter get _read => context.read<MainPagePresenter>();

  @override
  Widget build(BuildContext context) {
    return LoadingLayout(
      isLoading: _watch.isLoading,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _isIOS ? null : _buildFloatingActionButton(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final title = Text(_locale.userDictionaries);

    if (_isIOS) {
      return CupertinoNavigationBar(
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
    if (_watch.isInit) {
      return LoadingIndicator();
    }

    if (_watch.dictionaries.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(_locale.listEmptyInfo, textAlign: TextAlign.center),
      );
    }

    final dictionaries = _watch.dictionaries;
    return ListView.builder(
      itemCount: dictionaries.length,
      itemBuilder: (context, index) {
        final dictionary = dictionaries[index];
        return _DictionaryTile(
          isEven: (index + 1).isEven,
          dictionary: dictionary,
          onPressed: _onItemPressed,
          onEdit: _onItemEdit,
        );
      },
    );
  }

  Future<void> _onItemPressed(Dictionary dictionary) async {
    await Navigator.of(context).pushAndRemoveUntil(
      WordsPage(dictionary).createRoute(context),
      (route) => false,
    );
  }

  Future<void> _onItemEdit(Dictionary dictionary) async {
    final returnedValue = await Navigator.of(context).push(
      EditDictionaryPage(dictionary).createRoute(context),
    );

    if (returnedValue != null) {
      try {
        if (returnedValue.runtimeType == String) {
          await _read.removeDictionary(returnedValue);
        } else if (returnedValue.runtimeType == Dictionary) {
          await _read.editDictionary(returnedValue);
        }
      } on DictionaryNotExistException {
        showErrorMessage(context, _locale.dictionaryNotExistException);
      } catch (e) {
        //TODO: handle errors
        showErrorMessage(context, e.toString());
      }
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: _onAddNewDictionaryPressed,
    );
  }

  Future<void> _onAddNewDictionaryPressed() async {
    final returnedValue = await Navigator.of(context).push(
      NewDictionaryPage().createRoute(context),
    );

    if (returnedValue != null && returnedValue.runtimeType == Dictionary) {
      try {
        await _read.createDictionary(returnedValue);
      } on DictionaryAlreadyExistException {
        showErrorMessage(context, _locale.dictionaryAlreadyExistException);
      } catch (e) {
        //TODO: handle errors
        showErrorMessage(context, e.toString());
      }
    }
  }

  Widget _buildBottomNavigationBar() {
    final title = Text(_locale.changeUser);

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
      builder: dialogBuilder(context, _locale.askChangeUser, _onExit),
    );
  }

  Future<void> _onExit() async {
    try {
      Navigator.of(context).pop();
      await _read.changeUser();
      await Navigator.of(context).pushAndRemoveUntil(
        LoginPage().createRoute(context),
        (route) => false,
      );
    } on LogOutException {
      showErrorMessage(context, _locale.logOutException);
    } catch (e) {
      //TODO: handle errors
      showErrorMessage(context, e.toString());
    }
  }
}
