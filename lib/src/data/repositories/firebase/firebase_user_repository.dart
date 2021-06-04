import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/data/repositories/firebase/firestore_ids.dart';
import 'package:mydictionaryapp/src/data/utils/dictionaries_service.dart';
import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/language.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/user_repository.dart';

class FirebaseUserRepository extends UserRepository {
  late final _firestore = FirebaseFirestore.instance;
  late final _dictionariesService = GetIt.I<DictionariesService>();

  @override
  Future<List<Dictionary>> getDictionaries(String userId) async {
    final userDataJson = await _users.doc(userId).get();
    return _dictionariesFromJson(userDataJson.data());
  }

  @override
  Future<void> createNewDictionary(Dictionary dictionary, String userId) async {
    final dictionaryJson = await compute(_dictionaryToJson, dictionary);
    try {
      await _users.doc(userId).update({
        FirestoreIds.dictionaries: FieldValue.arrayUnion([dictionaryJson]),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        await _users.doc(userId).set({
          FirestoreIds.dictionaries: [dictionaryJson],
        });
        return;
      }
      rethrow;
    }
  }

  @override
  Future<void> editDictionary(Dictionary editedDictionary, String userId) async {
    final userDoc = _users.doc(userId);

    final dictionaries = await userDoc.get()
      .then((json) => _dictionariesFromJson(json.data()));
    final dictionaryJson = await compute(
      _dictionaryToJson,
      dictionaries.firstWhere((d) => d.id == editedDictionary.id),
    );

    await Future.wait([
      userDoc.update({
        FirestoreIds.dictionaries: FieldValue.arrayRemove([dictionaryJson]),
      }),
      userDoc.update({
        FirestoreIds.dictionaries: FieldValue.arrayUnion([
          await compute(_dictionaryToJson, editedDictionary),
        ]),
      }),
    ]);
  }

  @override
  Future<void> removeDictionary(String id, String userId) async {
    final userDoc = _users.doc(userId);

    final dictionaries = await userDoc.get()
      .then((json) => _dictionariesFromJson(json.data()));
    final dictionaryJson = await compute(
      _dictionaryToJson,
      dictionaries.firstWhere((d) => d.id == id),
    );

    await Future.wait([
      userDoc.update({
        FirestoreIds.dictionaries: FieldValue.arrayRemove([dictionaryJson]),
      }),
      userDoc.collection(id).get().then((words) {
        Future.wait(words.docs.map((word) => word.reference.delete()));
      })
    ]);
  }

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirestoreIds.users);

  Future<List<Dictionary>> _dictionariesFromJson(
    Map<String, dynamic>? userDataJson,
  ) async {
    if (userDataJson == null) {
      return [];
    }
    final List dictionariesJson = userDataJson[FirestoreIds.dictionaries];
    return Future.wait(
      dictionariesJson.map<Future<Dictionary>>(
        (json) async {
          final String langCode = json[FirestoreIds.originalLanguage];
          final language = await _dictionariesService.getLanguageByCode(langCode);
          return Dictionary(
            id: json[FirestoreIds.id],
            originalLanguage: language,
            title: json[FirestoreIds.title],
          );
        },
      ).toList(),
    );
  }

  @override
  Future<List<Language>> getDictionaryLanguages() =>
      _dictionariesService.getLanguages();
}

Map<String, dynamic> _dictionaryToJson(Dictionary dictionary) {
  return {
    FirestoreIds.id: dictionary.id,
    FirestoreIds.originalLanguage: dictionary.originalLanguage.code,
    FirestoreIds.title: dictionary.title,
  };
}
