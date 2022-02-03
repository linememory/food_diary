import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/datasources/entry_datasource.dart';
import 'package:food_diary/features/diary/data/models/symptom_dto.dart';
import 'package:sqflite/sqflite.dart';

abstract class SymptomDatasource {
  Future<List<SymptomDTO>> getAllForEntry(int entryId);
  Future<int> insert(SymptomDTO symptom);
  Future<int> delete(int entryId);
}

class SymptomDatasourceImpl extends SymptomDatasource {
  final DatabaseHelper _databaseHelper;

  bool isInit = false;

  static const String tableName = 'symptoms';
  static const String idColumn = 'id';
  static const String descriptionColumn = 'description';
  static const String intensityColumn = 'intensity';
  static const String entryIdColumn = 'entry_id';

  SymptomDatasourceImpl(this._databaseHelper);

  @override
  Future<List<SymptomDTO>> getAllForEntry(int entryId) async {
    _init();
    Database db = await _databaseHelper.database;
    return (await db
            .query(tableName, where: '$entryIdColumn = ?', whereArgs: [entryId]))
        .map((e) => SymptomDTO.fromMap(e))
        .toList();
  }

  @override
  Future<int> insert(SymptomDTO symptom) async {
    _init();
    Database db = await _databaseHelper.database;
    return await db.insert(tableName, symptom.toMap());
  }

  @override
  Future<int> delete(int entryId) async {
    _init();
    Database db = await _databaseHelper.database;
    return await db
        .delete(tableName, where: '$entryIdColumn = ?', whereArgs: [entryId]);
  }

  Future _init() async {
    if (!isInit) {
      await (await _databaseHelper.database).execute('''
        CREATE TABLE IF NOT EXISTS $tableName (
          $idColumn INTEGER PRIMARY KEY AUTOINCREMENT, 
          $descriptionColumn TEXT NOT NULL,
          $intensityColumn INTEGER NOT NULL,
          $entryIdColumn INTEGER NOT NULL,
          FOREIGN KEY ($entryIdColumn) REFERENCES ${EntryDatasourceImpl.tableName} (${EntryDatasourceImpl.idColumn})                  
              ON DELETE CASCADE ON UPDATE CASCADE
        )
      ''');
      isInit = true;
    }
  }
}
