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
part 'widgets/_main_screen_header.dart';

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
  ThemeData get _theme => Theme.of(context);
  MainPagePresenter get _watch => context.watch<MainPagePresenter>();
  MainPagePresenter get _read => context.read<MainPagePresenter>();

  @override
  Widget build(BuildContext context) {
    return LoadingLayout(
      isLoading: _watch.isLoading,
      child: Scaffold(
        appBar: _MainScreenHeader(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            tileColor: _theme.primaryColor.withOpacity(0.3),
            title: Text(
              _locale.userDictionaries,
              style: _theme.textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ),
          _buildDictionariesList(),
          _buildAddDictionaryButton(),
        ],
      ),
    );
  }

  Widget _buildDictionariesList() {
    if (_watch.isInit) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: LoadingIndicator(),
      );
    }

    if (_watch.dictionaries.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Text(_locale.listEmptyInfo, textAlign: TextAlign.center),
      );
    }

    final dictionaries = _watch.dictionaries;
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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

  Widget _buildAddDictionaryButton() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        width: double.infinity,
        child: ElevatedButton(
          child: Text(_locale.addNewDictionary),
          onPressed: _onAddNewDictionaryPressed,
        ),
      ),
    );
  }

  Future<void> _onAddNewDictionaryPressed() =>
    Navigator.of(context).push(NewDictionaryPage().createRoute(context));
}
