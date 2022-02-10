import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/datasources/entry_datasource.dart';
import 'package:food_diary/features/diary/data/models/bowel_movement_dto.dart';
import 'package:sqflite/sqflite.dart';

abstract class BowelMovementDatasource {
  Future<BowelMovementDTO?> getForEntry(int entryId);
  Future<int> insert(BowelMovementDTO bowelMovement);
  Future<int> delete(int entryId);
}

class BowelMovementDatasourceImpl extends BowelMovementDatasource {
  final DatabaseHelper _databaseHelper;

  bool isInit = false;

  static const String tableName = 'bowel_movements';
  static const String idColumn = 'id';
  static const String typeColumn = 'stool_type';
  static const String noteColumn = 'note';
  static const String entryIdColumn = 'entry_id';

  BowelMovementDatasourceImpl(this._databaseHelper);

  @override
  Future<BowelMovementDTO?> getForEntry(int entryId) async {
    _init();
    Database db = await _databaseHelper.database;
    final result = (await db
        .query(tableName, where: '$entryIdColumn = ?', whereArgs: [entryId]));
    if (result.isNotEmpty) {
      return BowelMovementDTO.fromMap(result.first);
    } else {
      return null;
    }
  }

  @override
  Future<int> insert(BowelMovementDTO bowelMovement) async {
    _init();
    Database db = await _databaseHelper.database;
    return db.insert(tableName, bowelMovement.toMap());
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
          $typeColumn INTEGER NOT NULL,
          $noteColumn TEXT NOT NULL,
          $entryIdColumn INTEGER NOT NULL,
          FOREIGN KEY ($entryIdColumn) REFERENCES ${EntryDatasourceImpl.tableName} (${EntryDatasourceImpl.idColumn})                  
              ON DELETE CASCADE ON UPDATE CASCADE
        )
        ''');
      isInit = true;
    }
  }
}
