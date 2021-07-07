part of '../main_page.dart';

class _MainScreenHeader extends StatefulWidget implements PreferredSizeWidget {
  final Size preferredSize;

  _MainScreenHeader() : preferredSize = Size.fromHeight(160.0);

  @override
  _MainScreenHeaderState createState() => _MainScreenHeaderState();
}

class _MainScreenHeaderState extends State<_MainScreenHeader> {
  MyDictionaryLocalizations get _locale => MyDictionaryLocalizations.of(context)!;
  ThemeData get _theme => Theme.of(context);
  MainPagePresenter get _watch => context.watch<MainPagePresenter>();
  MainPagePresenter get _read => context.read<MainPagePresenter>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _buildUserData()),
            _buildExitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserData() {
    if (_watch.isUserDataLoading) return Container();
    final userData = _watch.userData;
    if (userData == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(_locale.tryLogoutAndLoginToFetchUserData),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(userData.name, style: _theme.textTheme.headline6),
          Text(userData.email, style: _theme.textTheme.subtitle1),
        ],
      );
    }
  }

  Widget _buildExitButton() {
    if (Platform.isIOS) {
      return CupertinoButton(
        child: Text(_locale.exit),
        onPressed: _showDialogOnExit,
      );
    }
    return TextButton(
      child: Text(_locale.exit),
      onPressed: _showDialogOnExit,
    );
  }

  Future<void> _showDialogOnExit() async {
    await showDialog(
      context: context,
      builder: dialogBuilder(context, _locale.askToExit, _onExit),
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