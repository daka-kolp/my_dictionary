import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class DictionariesScreenPresenter extends ChangeNotifier {
  final _userRepository = GetIt.I<UserRepository>();
  final _fetchStep = GetIt.I<GlobalConfig>().fetchStep;

  List<Dictionary> _dictionaries = [];
  int _offset = 0;
  bool _isNewDictionariesAvailable = true;
  bool _isLoading = false;

  List<Dictionary> get dictionaries => _dictionaries;

  bool get isLoading => _isLoading;

  DictionariesScreenPresenter() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _dictionaries = await _userRepository.getDictionaries(_offset);
    } catch (e) {
      print('DictionariesScreenPresenter: _init() => $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadNewDictionaries() async {
    if (_isNewDictionariesAvailable) {
      _isLoading = true;
      notifyListeners();

      try {
        _offset += _fetchStep;

        final List<Dictionary> newDictionaries =
            await _userRepository.getDictionaries(_offset);

        if (newDictionaries.isEmpty) {
          _isNewDictionariesAvailable = false;
        } else {
          _dictionaries += newDictionaries;
        }
      } catch (e) {
        print('DictionariesScreenPresenter: uploadNewDictionaries() => $e');
        rethrow;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
