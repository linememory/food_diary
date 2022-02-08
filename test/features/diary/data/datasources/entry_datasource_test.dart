import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/datasources/entry_datasource.dart';
import 'package:food_diary/features/diary/data/models/entry_dto.dart';

import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late EntryDatasourceImpl datasource;
  late MockDatabaseHelper mockDatabasehelper;

  Database? db;

  sqfliteFfiInit();
  setUp(() async {
    mockDatabasehelper = MockDatabaseHelper();
    datasource = EntryDatasourceImpl(mockDatabasehelper);

    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  });

  tearDown(() async {
    await db?.close();
    return Future;
  });

  group('add entry to database', () {
    test('should add the entry and return the id of it', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      DateTime dateTime = DateTime.now();
      // act
      int result = await datasource
          .upsert(EntryDTO(dateTime: dateTime, type: EntryType.symptom));
      // assert

      List<Map<String, dynamic>> query =
          await db!.query(EntryDatasourceImpl.tableName);
      expect(query.length, 1);

      verify(() => mockDatabasehelper.database);
      expect(EntryDTO.fromMap(query.first),
          equals(EntryDTO(id: 1, dateTime: dateTime, type: EntryType.symptom)));
      expect(result, 1);
    });
  });

  group('get all entrys from database', () {
    test('should return all entrys', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      DateTime dateTime = DateTime.now();
      await datasource
          .upsert(EntryDTO(dateTime: dateTime, type: EntryType.symptom));
      // act
      List<EntryDTO> result = await datasource.getAll();
      // assert

      expect(result.length, 1);

      verify(() => mockDatabasehelper.database);
      expect(result.first,
          equals(EntryDTO(id: 1, dateTime: dateTime, type: EntryType.symptom)));
    });
  });

  group('get all entrys for given month from database', () {
    test('should return all entrys for given month', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      DateTime dateTime = DateTime.now();
      await datasource
          .upsert(EntryDTO(dateTime: dateTime, type: EntryType.symptom));
      await datasource.upsert(EntryDTO(
          dateTime: DateTime.fromMicrosecondsSinceEpoch(0),
          type: EntryType.symptom));
      // act
      List<EntryDTO> result = await datasource.getAllForMonth(dateTime);
      // assert

      expect(result.length, 1);

      verify(() => mockDatabasehelper.database);
      expect(result.first,
          equals(EntryDTO(id: 1, dateTime: dateTime, type: EntryType.symptom)));
    });
  });

  group('update entry in database', () {
    test('should update the entry and return the id of it', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      DateTime dateTime = DateTime.now();
      int id = await datasource
          .upsert(EntryDTO(dateTime: dateTime, type: EntryType.symptom));
      // act
      int result = await datasource.upsert(EntryDTO(
          id: id,
          dateTime: DateTime.fromMicrosecondsSinceEpoch(0),
          type: EntryType.symptom));
      // assert

      List<Map<String, dynamic>> query =
          await db!.query(EntryDatasourceImpl.tableName);
      expect(query.length, 1);

      verify(() => mockDatabasehelper.database);
      expect(
          EntryDTO.fromMap(query.first),
          equals(EntryDTO(
              id: 1,
              dateTime: DateTime.fromMicrosecondsSinceEpoch(0),
              type: EntryType.symptom)));
      expect(result, 1);
    });
  });

  group('delete entry from database', () {
    test('should delete the entry and return the the number of changes',
        () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      DateTime dateTime = DateTime.now();
      int id = await datasource
          .upsert(EntryDTO(dateTime: dateTime, type: EntryType.symptom));
      // act
      int result = await datasource.delete(id);
      // assert

      List<Map<String, dynamic>> query =
          await db!.query(EntryDatasourceImpl.tableName);
      expect(query.length, 0);
      verify(() => mockDatabasehelper.database);
      expect(result, 1);
    });
  });
}
