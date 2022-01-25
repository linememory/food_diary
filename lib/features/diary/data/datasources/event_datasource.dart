import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/models/event_dto.dart';
import 'package:sqflite/sqflite.dart';

abstract class EventDatasource {
  Future<List<EventDTO>> getAll();
  Future<int> upsert(EventDTO event);
  Future<int> delete(int id);
}

class EventDatasourceImpl extends EventDatasource {
  final DatabaseHelper2 _databaseHelper;

  bool isInit = false;

  static const String tableName = 'events';
  static const String idColumn = 'id';
  static const String dateTimeColumn = 'date_time';
  static const String typeColumn = 'type';

  EventDatasourceImpl(this._databaseHelper);

  @override
  Future<List<EventDTO>> getAll() async {
    _init();
    Database db = await _databaseHelper.database;
    return (await db.query(tableName)).map((e) => EventDTO.fromMap(e)).toList();
  }

  @override
  Future<int> upsert(EventDTO event) async {
    _init();
    Database db = await _databaseHelper.database;
    if (event.id != null) {
      final result = await db
          .query(tableName, where: '$idColumn = ?', whereArgs: [event.id]);
      if (result.isNotEmpty) {
        await db.update(tableName, event.toMap());
        return result.first[idColumn] as int;
      } else {
        return await db.insert(tableName, event.toMap());
      }
    } else {
      final result = await db.query(tableName,
          where: '$dateTimeColumn = ?',
          whereArgs: [event.dateTime.microsecondsSinceEpoch]);
      for (var item in result) {
        if (item[dateTimeColumn] == event.dateTime.microsecondsSinceEpoch &&
            item[typeColumn] == event.type.index) {
          await db.update(tableName, event.toMap(),
              where: '$dateTimeColumn = ?', whereArgs: [event.dateTime]);
          return item[idColumn] as int;
        }
      }
      return await db.insert(tableName, event.toMap());
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
