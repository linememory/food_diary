import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/datasources/event_datasource.dart';
import 'package:food_diary/features/diary/data/models/symptom_dto.dart';
import 'package:sqflite/sqflite.dart';

abstract class SymptomDatasource {
  Future<List<SymptomDTO>> getAllForEvent(int eventId);
  Future<int> insert(SymptomDTO symptom);
  Future<int> delete(int eventId);
}

class SymptomDatasourceImpl extends SymptomDatasource {
  final DatabaseHelper2 _databaseHelper;

  bool isInit = false;

  static const String tableName = 'symptoms';
  static const String idColumn = 'id';
  static const String descriptionColumn = 'description';
  static const String eventIdColumn = 'event_id';

  SymptomDatasourceImpl(this._databaseHelper);

  @override
  Future<List<SymptomDTO>> getAllForEvent(int eventId) async {
    _init();
    Database db = await _databaseHelper.database;
    return (await db
            .query(tableName, where: '$idColumn = ?', whereArgs: [eventId]))
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
  Future<int> delete(int eventId) async {
    _init();
    Database db = await _databaseHelper.database;
    return await db
        .delete(tableName, where: '$eventIdColumn = ?', whereArgs: [eventId]);
  }

  Future _init() async {
    if (!isInit) {
      await (await _databaseHelper.database).execute('''
    CREATE TABLE IF NOT EXISTS $tableName (
      $idColumn INTEGER PRIMARY KEY AUTOINCREMENT, 
      $descriptionColumn TEXT NOT NULL,
      $eventIdColumn INTEGER NOT NULL,
      FOREIGN KEY ($eventIdColumn) REFERENCES ${EventDatasourceImpl.tableName} (${EventDatasourceImpl.idColumn})                  
           ON DELETE CASCADE ON UPDATE CASCADE
    )
    ''');
      isInit = true;
    }
  }
}
