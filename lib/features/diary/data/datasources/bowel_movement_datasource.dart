import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/datasources/event_datasource.dart';
import 'package:food_diary/features/diary/data/models/bowel_movement_dto.dart';
import 'package:sqflite/sqflite.dart';

abstract class BowelMovementDatasource {
  Future<BowelMovementDTO> getForEvent(int eventId);
  Future<int> insert(BowelMovementDTO bowelMovement);
  Future<int> delete(int eventId);
}

class BowelMovementDatasourceImpl extends BowelMovementDatasource {
  final DatabaseHelper2 _databaseHelper;

  bool isInit = false;

  static const String tableName = 'bowel_movements';
  static const String idColumn = 'id';
  static const String typeColumn = 'stool_type';
  static const String noteColumn = 'note';
  static const String eventIdColumn = 'event_id';

  BowelMovementDatasourceImpl(this._databaseHelper);

  @override
  Future<BowelMovementDTO> getForEvent(int eventId) async {
    _init();
    Database db = await _databaseHelper.database;
    return BowelMovementDTO.fromMap((await db
            .query(tableName, where: '$idColumn = ?', whereArgs: [eventId]))
        .first);
  }

  @override
  Future<int> insert(BowelMovementDTO bowelMovement) async {
    _init();
    Database db = await _databaseHelper.database;
    return db.insert(tableName, bowelMovement.toMap());
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
          $typeColumn INTEGER NOT NULL,
          $noteColumn TEXT NOT NULL,
          $eventIdColumn INTEGER NOT NULL,
          FOREIGN KEY ($eventIdColumn) REFERENCES ${EventDatasourceImpl.tableName} (${EventDatasourceImpl.idColumn})                  
              ON DELETE CASCADE ON UPDATE CASCADE
        )
        ''');
      isInit = true;
    }
  }
}
