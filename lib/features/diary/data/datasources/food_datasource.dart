import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/datasources/entry_datasource.dart';
import 'package:food_diary/features/diary/data/models/food_dto.dart';
import 'package:sqflite/sqflite.dart';

abstract class FoodDatasource {
  Future<List<FoodDTO>> getForEntry(int entryId);
  Future<int> insert(FoodDTO bowelMovement);
  Future<int> delete(int entryId);
}

class FoodDatasourceImpl implements FoodDatasource {
  final DatabaseHelper _databaseHelper;

  bool isInit = false;

  static const String tableName = 'foods';
  static const String idColumn = 'id';
  static const String nameColumn = 'name';
  static const String amountColumn = 'amount';
  static const String entryIdColumn = 'entry_id';

  FoodDatasourceImpl(this._databaseHelper);

  @override
  Future<List<FoodDTO>> getForEntry(int entryId) async {
    _init();
    Database db = await _databaseHelper.database;
    return (await db.query(tableName,
            where: '$entryIdColumn = ?', whereArgs: [entryId]))
        .map((e) => FoodDTO.fromMap(e))
        .toList();
  }

  @override
  Future<int> insert(FoodDTO food) async {
    _init();
    Database db = await _databaseHelper.database;
    return await db.insert(tableName, food.toMap());
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
          $nameColumn TEXT NOT NULL,
          $amountColumn INTEGER NOT NULL,
          $entryIdColumn INTEGER NOT NULL,
          FOREIGN KEY ($entryIdColumn) REFERENCES ${EntryDatasourceImpl.tableName} (${EntryDatasourceImpl.idColumn})                  
              ON DELETE CASCADE ON UPDATE CASCADE
        )
      ''');
      isInit = true;
    }
  }
}
