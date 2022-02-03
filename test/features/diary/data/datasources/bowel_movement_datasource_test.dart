import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/datasources/bowel_movement_datasource.dart';
import 'package:food_diary/features/diary/data/models/bowel_movement_dto.dart';

import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late BowelMovementDatasource datasource;
  late MockDatabaseHelper mockDatabasehelper;

  Database? db;

  BowelMovementDTO bowelMovement =
      const BowelMovementDTO(stoolType: 0, note: "Test", entryId: 1);

  sqfliteFfiInit();
  setUp(() async {
    mockDatabasehelper = MockDatabaseHelper();
    datasource = BowelMovementDatasourceImpl(mockDatabasehelper);
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  });

  tearDown(() async {
    await db?.close();
    return Future;
  });

  group('add bowel movement to database', () {
    test('should add the bowel movement and return the id of it', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);

      // act
      int result = await datasource.insert(bowelMovement);
      // assert

      expect(result, 1);
      List<Map<String, dynamic>> query =
          await db!.query(BowelMovementDatasourceImpl.tableName);
      expect(query.length, 1);

      verify(() => mockDatabasehelper.database);
      expect(BowelMovementDTO.fromMap(query.first), equals(bowelMovement));
    });
  });

  group('get bowel movement from database', () {
    test('should return all bowel movements for meal ID', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      await datasource.insert(bowelMovement);
      // act
      BowelMovementDTO? result = await datasource.getForEntry(1);
      // assert

      verify(() => mockDatabasehelper.database);
      expect(result, equals(bowelMovement));
    });

    test('should return no bowel movement for meal ID', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      await datasource.insert(bowelMovement);
      // act
      BowelMovementDTO? result = await datasource.getForEntry(0);
      // assert

      verify(() => mockDatabasehelper.database);
      expect(result, equals(null));
    });
  });

  group('delete bowel movement from database', () {
    test('should delete the bowel movement and return the number of changes',
        () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      int id = await datasource.insert(bowelMovement);
      // act
      int result = await datasource.delete(id);
      // assert

      List<Map<String, dynamic>> query =
          await db!.query(BowelMovementDatasourceImpl.tableName);
      expect(query.length, 0);
      verify(() => mockDatabasehelper.database);
      expect(result, 1);
    });

    test('should not delete any bowel movement and return 0', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      await datasource.insert(bowelMovement);
      // act
      int result = await datasource.delete(0);
      // assert

      List<Map<String, dynamic>> query =
          await db!.query(BowelMovementDatasourceImpl.tableName);
      expect(query.length, 1);
      verify(() => mockDatabasehelper.database);
      expect(result, 0);
    });
  });
}
