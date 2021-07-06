import 'package:cloud_firestore/cloud_firestore.dart';
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
    final dictionaryJson = _dictionaryToJson(dictionary);
    final doc = _users.doc(userId);
    try {
      await Future.wait([
        doc.update({
          FirestoreIds.dictionaries: FieldValue.arrayUnion([dictionaryJson]),
        }),
        if (dictionary.isMain)
          doc.update({
            FirestoreIds.mainDictionaryId: dictionary.id,
          }),
      ]);
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        await _users.doc(userId).set({
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
    final userDoc = _users.doc(userId);

    final dictionaries = await userDoc.get()
      .then((json) => _dictionariesFromJson(json.data()));
    final dictionaryJson = _dictionaryToJson(
      dictionaries.firstWhere((d) => d.id == editedDictionary.id),
    );

    await Future.wait([
      userDoc.update({
        FirestoreIds.dictionaries: FieldValue.arrayRemove([dictionaryJson]),
      }),
      userDoc.update({
        FirestoreIds.dictionaries: FieldValue.arrayUnion([
          _dictionaryToJson(editedDictionary),
        ]),
      }),
      if (editedDictionary.isMain)
        _users.doc(userId).update({
          FirestoreIds.mainDictionaryId: editedDictionary.id,
        }),
    ]);
  }

  @override
  Future<void> removeDictionary(String id, String userId) async {
    final userDoc = _users.doc(userId);
    final json = await userDoc.get();
    final mainDictionaryId = (json.data())?[FirestoreIds.mainDictionaryId] ?? '';
    final dictionaries = await _dictionariesFromJson(json.data());
    final dictionaryJson = _dictionaryToJson(
      dictionaries.firstWhere((d) => d.id == id),
    );

    await Future.wait([
      userDoc.update({
        FirestoreIds.dictionaries: FieldValue.arrayRemove([dictionaryJson]),
      }),
      if(mainDictionaryId == id)
        userDoc.update({
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

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirestoreIds.users);

  Future<List<Dictionary>> _dictionariesFromJson(
    Map<String, dynamic>? userDataJson,
  ) async {
    if (userDataJson == null) {
      return [];
    }
    final String mainDictionaryId = userDataJson[FirestoreIds.mainDictionaryId] ?? '';
    final List dictionariesJson = userDataJson[FirestoreIds.dictionaries];
    final dictionaries = await Future.wait(
      dictionariesJson.map<Future<Dictionary>>(
        (json) async {
          final String langCode = json[FirestoreIds.originalLanguage];
          final language = await _dictionariesService.getLanguageByCode(langCode);
          return Dictionary(
            id: json[FirestoreIds.id],
            originalLanguage: language,
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
