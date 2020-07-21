import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';
import 'package:mydictionaryapp/src/utils/dimens.dart';

class DictionariesScreenPresenter extends ChangeNotifier {
  final BuildContext context;
  final _userRepository = GetIt.I<UserRepository>();
  final _fetchStep = GetIt.I<GlobalConfig>().fetchStep;

  List<Dictionary> _dictionaries;
  int _offset = 0;
  bool _isNewDictionariesAvailable = true;
  bool _isNewDictionariesLoading = false;

  List<Dictionary> get dictionaries => _dictionaries;
  bool get isNewDictionariesLoading => _isNewDictionariesLoading;
  bool get isLoading => _dictionaries == null;

  DictionariesScreenPresenter(this.context) {
    _init();
  }

  Future<void> _init() async {
    try {
      _dictionaries = await _userRepository.getAndRegisterDictionaries(_offset);
      if (_isScrollControllerNotActive) {
        await uploadNewDictionaries();
      }
    } catch (e) {
      print('DictionariesScreenPresenter: _init() => $e');
      rethrow;
    } finally {
      _isNewDictionariesLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadNewDictionaries() async {
    if (_isNewDictionariesAvailable) {
      _isNewDictionariesLoading = true;
      notifyListeners();

      try {
        _offset += _fetchStep;
        final newDictionaries = await _userRepository.getAndRegisterDictionaries(_offset);

        if (newDictionaries.isEmpty) {
          _isNewDictionariesAvailable = false;
        } else {
          _dictionaries += newDictionaries;
        }
        if (_isScrollControllerNotActive) {
          await uploadNewDictionaries();
        }
      } on RangeError catch (e) {
        print(e.message);
        _isNewDictionariesAvailable = false;
      } catch (e) {
        print('DictionariesScreenPresenter: uploadNewDictionaries() => $e');
        rethrow;
      } finally {
        _isNewDictionariesLoading = false;
        notifyListeners();
      }
    }
  }

  bool get _isScrollControllerNotActive =>
      dictionaryTileHeight * _dictionaries.length <
      MediaQuery.of(context).size.height;
}
