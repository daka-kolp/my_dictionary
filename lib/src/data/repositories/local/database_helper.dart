import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:mydictionaryapp/src/domain/entities/dictionary.dart';
import 'package:mydictionaryapp/src/domain/entities/word.dart';

class DatabaseHelper {
  static final _databaseName = "MyDictionariesDatabase.db";
  static final _databaseVersion = 1;

  static final _dictionariesTable = 'dictionaries_table';
  static final _wordsTable = 'words_table';
  static final _translationsTable = 'translations_table';

  static final _dictionaryId = '_id';
  static final _originalLanguage = 'original_language';
  static final _translationLanguage = 'translation_language';
  static final _title = 'title';

  static final _wordId = '_id';
  static final _word = 'word';
  static final _hint = 'hint';
  static final _time = 'time';

  static final _translationId = '_id';
  static final _translation = 'translation';

  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    return _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $_dictionariesTable (
            $_dictionaryId TEXT PRIMARY KEY,
            $_originalLanguage TEXT NOT NULL,
            $_translationLanguage TEXT NOT NULL,
            $_title TEXT NOT NULL,
          )
          ''');
    await db.execute('''
          CREATE TABLE $_wordsTable (
            $_wordId TEXT PRIMARY KEY,
            $_dictionaryId TEXT,
            $_word TEXT NOT NULL,
            $_hint TEXT,
            $_time INT NOT NULL,
          )
          ''');
    await db.execute('''
          CREATE TABLE $_translationsTable (
            $_translationId TEXT PRIMARY KEY,
            $_wordId TEXT NOT NULL,
            $_translation TEXT NOT NULL,
          )
          ''');
  }

  Future<int> insertDictionary(Dictionary dictionary) async {
    final db = await instance.database;
    final dictionaryMap = {
      _dictionaryId: dictionary.id,
      _originalLanguage: dictionary.originalLanguage,
      _translationLanguage: dictionary.translationLanguage,
      _title: dictionary.title,
    };
    return await db.insert(_dictionariesTable, dictionaryMap);
  }

  Future<int> insertWord(String dictionaryId, Word word) async {
    final db = await instance.database;
    final wordMap = {
      _wordId: word.id,
      _dictionaryId: dictionaryId,
      _word: word.word,
      _hint: word.hint,
      _time: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
    return await db.insert(_wordsTable, wordMap);
  }

  Future<int> insertTranslation(String wordId, Translation translation) async {
    final db = await instance.database;
    final translationMap = {
      _translationId: translation.id,
      _wordId: wordId,
      _translation: translation.translation,
    };
    return await db.insert(_translationsTable, translationMap);
  }

  Future<List<Dictionary>> queryDictionaries(
    int offset,
    int limit,
  ) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> dictionariesMaps = await db.query(
      _dictionariesTable,
      offset: offset,
      limit: limit,
    );

    return List.generate(
      dictionariesMaps.length,
      (i) => Dictionary(
        id: dictionariesMaps[i][_dictionaryId],
        originalLanguage: dictionariesMaps[i][_originalLanguage],
        translationLanguage: dictionariesMaps[i][_translationLanguage],
        title: dictionariesMaps[i][_title],
      ),
    );
  }

  Future<List<Word>> queryWords(
    String dictionaryId,
    int offset,
    int limit,
  ) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> wordsMaps = await db.query(
      _wordsTable,
      where: '$_dictionaryId = ?',
      whereArgs: [dictionaryId],
      orderBy: _time,
      offset: offset,
      limit: limit,
    );

    final Map<String, List<Translation>> translationsMap =
        await Stream.fromIterable(wordsMaps).forEach((w) async {
      final translationList = await _queryTranslations(w[_wordId]);
      return MapEntry(w[_wordId], translationList);
    });

    return List.generate(
      wordsMaps.length,
      (i) => Word(
        id: wordsMaps[i][_wordId],
        word: wordsMaps[i][_word],
        hint: wordsMaps[i][_hint],
        addingTime: wordsMaps[i][_time],
        translations: translationsMap[wordsMaps[i][_wordId]],
      ),
    );
  }

  Future<List<Translation>> _queryTranslations(String wordId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> translationsMaps = await db.query(
      _translationsTable,
      where: '$_wordId = ?',
      whereArgs: [wordId],
    );

    return List.generate(
      translationsMaps.length,
      (i) => Translation(
        id: translationsMaps[i][_translationId],
        translation: translationsMaps[i][_translation],
      ),
    );
  }
}
