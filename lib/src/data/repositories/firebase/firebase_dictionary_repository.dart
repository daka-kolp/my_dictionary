import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/data/utils/store_interator.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class FirebaseDictionaryRepository extends DictionaryRepository {
  final Firestore _fireStore = Firestore.instance;
  final StoreInteractor _storeInteractor;
  DocumentSnapshot _lastDocument;

  FirebaseDictionaryRepository(Dictionary dictionary)
      : _storeInteractor = GetIt.I<StoreInteractor>(),
        super(dictionary);

  @override
  Future<List<Word>> getWords([int offset]) async {
    final _fetchStep = GetIt.I<GlobalConfig>().fetchStep;
    final token = await _storeInteractor.getToken();
    final collection = _fireStore
        .collection('users')
        .document(token)
        .collection('en-GB_ru-RU');

    List<Word> words = [];
    QuerySnapshot docs;
    if (_lastDocument == null) {
      docs = await collection
          .orderBy('addingTime', descending: true)
          .limit(_fetchStep)
          .getDocuments();
    } else {
      docs = await collection
          .orderBy('addingTime', descending: true)
          .startAfterDocument(_lastDocument)
          .limit(_fetchStep)
          .getDocuments();
    }
    if (docs.documents.isNotEmpty) {
      _lastDocument = docs.documents[docs.documents.length - 1];
    }
    docs.documents.forEach((doc) {
      words.add(Word.fromJson(doc.data));
    });
    return words;
  }

  @override
  Future<void> addNewWord(Word newWord) async {
    try {
      final token = await _storeInteractor.getToken();

      await _fireStore
          .collection('users')
          .document(token)
          .collection('en-GB_ru-RU')
          .document(newWord.id)
          .setData(newWord.toJson());
    } catch (e) {
      throw WordAlreadyExistException();
    }
  }

  @override
  Future<void> editWord(Word word) async {
    try {
      final token = await _storeInteractor.getToken();

      await _fireStore
          .collection('users')
          .document(token)
          .collection('en-GB_ru-RU')
          .document(word.id)
          .setData(word.toJson());
    } catch (e) {
      throw WordAlreadyExistException();
    }
  }

  @override
  Future<void> removeWord(String id) async {
    try {
      final token = await _storeInteractor.getToken();
      final snapshot = await _fireStore
          .collection('users')
          .document(token)
          .collection('en-GB_ru-RU')
          .document(id)
          .get();

      if (snapshot.exists) {
        await _fireStore
            .collection('users')
            .document(token)
            .collection('en-GB_ru-RU')
            .document(id)
            .delete();
      }
    } catch (e) {
      throw WordNotExistException();
    }
  }

  @override
  void reset() {
    _lastDocument = null;
  }
}
