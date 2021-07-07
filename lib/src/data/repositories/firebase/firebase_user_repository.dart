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

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirestoreIds.users);

  @override
  Future<List<Dictionary>> getDictionaries(String userId) async {
    final userDoc = await _users.doc(userId).get();
    return _dictionariesFromJson(userDoc.data());
  }

  @override
  Future<void> createNewDictionary(Dictionary dictionary, String userId) async {
    final userDocRef = _users.doc(userId);
    final dictionaryJson = _dictionaryToJson(dictionary);
    try {
      await Future.wait([
        userDocRef.update({
          FirestoreIds.dictionaries: FieldValue.arrayUnion([dictionaryJson]),
        }),
        if (dictionary.isMain)
          userDocRef.update({FirestoreIds.mainDictionaryId: dictionary.id}),
      ]);
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        await userDocRef.set({
          FirestoreIds.mainDictionaryId: dictionary.id,
          FirestoreIds.dictionaries: [dictionaryJson],
        });
        return;
      }
      rethrow;
    }
  }

  @override
  Future<void> editDictionary(Dictionary editedDictionary, String userId) async {
    final userDocRef = _users.doc(userId);
    final userData = await userDocRef.get().then((value) => value.data()) ?? {};
    final dictionaryJson = _dictionaryToJson(editedDictionary);
    late final oldDictionaryJson;
    try {
      final dictionariesJson = userData[FirestoreIds.dictionaries] ?? [];
      oldDictionaryJson = dictionariesJson
        .firstWhere((json) => json[FirestoreIds.id] == editedDictionary.id);
    } catch (_) {
      oldDictionaryJson = {};
    }

    if (!mapEquals(dictionaryJson, oldDictionaryJson)) {
      await Future.wait([
        userDocRef.update({
          FirestoreIds.dictionaries: FieldValue.arrayUnion([dictionaryJson]),
        }),
        userDocRef.update({
          FirestoreIds.dictionaries: FieldValue.arrayRemove([oldDictionaryJson]),
        }),
      ]);
    }
    if (editedDictionary.isMain) {
      await userDocRef.update({
        FirestoreIds.mainDictionaryId: editedDictionary.id,
      });
    } else {
      final mainDictionaryId = userData[FirestoreIds.mainDictionaryId] ?? '';
      if(mainDictionaryId == editedDictionary.id) {
        await userDocRef.update({
          FirestoreIds.mainDictionaryId: FieldValue.delete(),
        });
      }
    }
  }

  @override
  Future<void> removeDictionary(String id, String userId) async {
    final userDoc = _users.doc(userId);
    final userData = await userDoc.get().then((value) => value.data()) ?? {};
    final mainDictionaryId = userData[FirestoreIds.mainDictionaryId] ?? '';
    final dictionariesJson = userData[FirestoreIds.dictionaries] ?? [];
    final dictionaryJson = dictionariesJson
        .firstWhere((json) => json[FirestoreIds.id] == id);

    await Future.wait([
      userDoc.update({
        FirestoreIds.dictionaries: FieldValue.arrayRemove([dictionaryJson]),
        if (mainDictionaryId == id)
          FirestoreIds.mainDictionaryId: FieldValue.delete(),
      }),
      userDoc.collection(id).get().then((words) {
        Future.wait(words.docs.map((word) => word.reference.delete()));
      })
    ]);
  }

  @override
  Future<List<Language>> getDictionaryLanguages() =>
      _dictionariesService.getLanguages();

  Future<List<Dictionary>> _dictionariesFromJson(
    Map<String, dynamic>? userDataJson,
  ) async {
    if (userDataJson == null) return [];
    final String mainDictionaryId = userDataJson[FirestoreIds.mainDictionaryId] ?? '';
    final List dictionariesJson = userDataJson[FirestoreIds.dictionaries];
    final dictionaries = await Future.wait(
      dictionariesJson.map<Future<Dictionary>>(
        (json) async {
          return Dictionary(
            id: json[FirestoreIds.id],
            originalLanguage: await _dictionariesService.getLanguageByCode(
              json[FirestoreIds.originalLanguage],
            ),
            title: json[FirestoreIds.title],
            isMain: mainDictionaryId == json[FirestoreIds.id],
          );
        },
      ).toList(),
    );
    return dictionaries..sort((d1, d2) => d1.title.compareTo(d2.title));
  }

  Map<String, dynamic> _dictionaryToJson(Dictionary dictionary) {
    return {
      FirestoreIds.id: dictionary.id,
      FirestoreIds.originalLanguage: dictionary.originalLanguage.code,
      FirestoreIds.title: dictionary.title,
    };
  }
}
