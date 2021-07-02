import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/data/repositories/firebase/firestore_ids.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/dictionary_repository.dart';
import 'package:mydictionaryapp/src/global_config.dart';

class FirebaseDictionaryRepository extends DictionaryRepository {
  late final _firestore = FirebaseFirestore.instance;
  late final _fetchStep = GetIt.I<GlobalConfig>().fetchStep;

  DocumentSnapshot? _lastDocument;

  @override
  Future<List<Word>> getWords(String userId, String dictionaryId) async {
    final query = _dictionaryRef(userId, dictionaryId)
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
      querySnapshot.docs.map((doc) => compute(_wordFromJson, doc.data())),
    );
  }

  @override
  Future<void> addWord(
    String userId,
    String dictionaryId,
    Word newWord,
  ) async {
    final query = await _dictionaryRef(userId, dictionaryId).where(
      FirestoreIds.word, isEqualTo: newWord.word,
    ).get();

    if (query.docs.isNotEmpty) {
      throw WordAlreadyExistException(newWord.word);
    }

    await _dictionaryRef(userId, dictionaryId)
      .doc(newWord.id)
      .set(await compute(_wordToJson, newWord));
  }

  @override
  Future<void> editWord(String userId, String dictionaryId, Word word) async {
    await _dictionaryRef(userId, dictionaryId)
      .doc(word.id)
      .update(await compute(_wordToJson, word));
  }

  @override
  Future<void> removeWord(String userId, String dictionaryId, String id) async {
    final snapshot = await _dictionaryRef(userId, dictionaryId).doc(id).get();
    if (snapshot.exists) {
      await _dictionaryRef(userId, dictionaryId).doc(id).delete();
    }
  }

  @override
  void reset() {
    _lastDocument = null;
  }

  CollectionReference<Map<String, dynamic>> _dictionaryRef(
    String userId,
    String dictionaryId,
  ) {
    return _firestore
        .collection(FirestoreIds.users)
        .doc(userId)
        .collection(dictionaryId);
  }
}

Word _wordFromJson(Map<String, dynamic> json) {
  return Word(
    id: json[FirestoreIds.id],
    word: json[FirestoreIds.word],
    translations: json[FirestoreIds.translations]
        .map<Translation>((e) => Translation(
              id: e[FirestoreIds.id],
              translation: e[FirestoreIds.translation],
            ))
        .toList(),
    hint: json[FirestoreIds.hint],
    addingTime: (json[FirestoreIds.addingTime] as Timestamp).toDate(),
    isLearned: json[FirestoreIds.isLearned],
  );
}

Map<String, dynamic> _wordToJson(Word word) {
  return {
    FirestoreIds.id: word.id,
    FirestoreIds.word: word.word,
    FirestoreIds.translations: word.translations
        .map((t) => {
              FirestoreIds.id: t.id,
              FirestoreIds.translation: t.translation,
            })
        .toList(),
    FirestoreIds.hint: word.hint,
    FirestoreIds.addingTime: Timestamp.fromDate(word.addingTime),
    FirestoreIds.isLearned: word.isLearned,
  };
}
