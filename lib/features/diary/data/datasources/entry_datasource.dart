import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/models/entry_dto.dart';
import 'package:sqflite/sqflite.dart';

abstract class EntryDatasource {
  Future<List<EntryDTO>> getAll();
  Future<int> upsert(EntryDTO entry);
  Future<int> delete(int id);
}

class EntryDatasourceImpl extends EntryDatasource {
  final DatabaseHelper _databaseHelper;

  bool isInit = false;

  static const String tableName = 'entries';
  static const String idColumn = 'id';
  static const String dateTimeColumn = 'date_time';
  static const String typeColumn = 'type';

  EntryDatasourceImpl(this._databaseHelper);

  @override
  Future<List<EntryDTO>> getAll() async {
    _init();
    Database db = await _databaseHelper.database;
    return (await db.query(tableName)).map((e) => EntryDTO.fromMap(e)).toList();
  }

  @override
  Future<int> upsert(EntryDTO entry) async {
    _init();
    Database db = await _databaseHelper.database;
    if (entry.id != null) {
      final result = await db
          .query(tableName, where: '$idColumn = ?', whereArgs: [entry.id]);
      if (result.isNotEmpty) {
        await db.update(tableName, entry.toMap()..remove(idColumn),
            where: '$idColumn = ?', whereArgs: [entry.id]);

            
        return result.first[idColumn] as int;
      } else {
        return await db.insert(tableName, entry.toMap());
      }
    } else {
      final result = await db.query(tableName,
          where: '$dateTimeColumn = ?',
          whereArgs: [entry.dateTime.microsecondsSinceEpoch]);
      for (var item in result) {
        if (item[dateTimeColumn] == entry.dateTime.microsecondsSinceEpoch &&
            item[typeColumn] == entry.type.index) {
          await db.update(tableName, entry.toMap(),
              where: '$dateTimeColumn = ?', whereArgs: [entry.dateTime]);
          return item[idColumn] as int;
        }
      }
      return await db.insert(tableName, entry.toMap());
    }
  }

  @override
  Future<int> delete(int id) async {
    _init();
    Database db = await _databaseHelper.database;
    return await db.delete(tableName, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future _init() async {
    if (!isInit) {
      await (await _databaseHelper.database).execute('''
    CREATE TABLE IF NOT EXISTS $tableName (
      $idColumn INTEGER PRIMARY KEY AUTOINCREMENT, 
      $dateTimeColumn INTEGER NOT NULL,
      $typeColumn INTEGER NOT NULL
    )
    ''');
      isInit = true;
    }
  }
}
