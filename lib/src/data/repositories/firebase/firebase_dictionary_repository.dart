import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/data/repositories/firebase/firestore_ids.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class FirebaseDictionaryRepository extends DictionaryRepository {
  late final _firestore = FirebaseFirestore.instance;
  late final _fetchStep = GetIt.I<GlobalConfig>().fetchStep;

  @override
  Future<List<Word>> getWords(
    int firstIndex,
    int offset,
    String userId,
    String dictionaryId,
  ) async {
    final query = _dictionaryReference(userId, dictionaryId)
        .orderBy(FirestoreIds.addingTime, descending: true)
        .limit(_fetchStep);
    final querySnapshot = _lastDocument == null
        ? await query.get()
        : await query.startAfterDocument(_lastDocument!).get();
    if (querySnapshot.docs.isEmpty) {
      return [];
    }
    _lastDocument = querySnapshot.docs.last;
    return Future.wait(
      querySnapshot.docs.map((doc) => compute(_parseWordFromJson, doc.data())),
    );
  }

  @override
  Future<void> addNewWord(
    Word newWord,
    String userId,
    String dictionaryId,
  ) {
    // TODO: implement addNewWord
    throw UnimplementedError();
  }

  @override
  Future<void> editWord(Word word, String userId, String dictionaryId) {
    // TODO: implement editWord
    throw UnimplementedError();
  }

  @override
  Future<void> removeWord(String id, String userId, String dictionaryId) {
    // TODO: implement removeWord
    throw UnimplementedError();
  }

  @override
  void reset() {
    _lastDocument = null;
  }

  DocumentSnapshot? _lastDocument;

  CollectionReference<Map<String, dynamic>> _dictionaryReference(
    String userId,
    String dictionaryId,
  ) {
    return _firestore
        .collection(FirestoreIds.users)
        .doc(userId)
        .collection(dictionaryId);
  }
}

Word _parseWordFromJson(Map<String, dynamic> json) {
  return Word(
    id: json[FirestoreIds.id],
    word: json[FirestoreIds.word],
    translations: json[FirestoreIds.translations]
        .map<Translation>(
          (e) => Translation(
            id: e[FirestoreIds.id],
            translation: e[FirestoreIds.translation],
          ),
        )
        .toList(),
    hint: json[FirestoreIds.hint],
    addingTime: json[FirestoreIds.addingTime].toDate(),
  );
}
