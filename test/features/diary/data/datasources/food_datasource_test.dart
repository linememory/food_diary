import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/datasources/food_datasource.dart';
import 'package:food_diary/features/diary/data/models/food_dto.dart';

import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late FoodDatasourceImpl datasource;
  late MockDatabaseHelper mockDatabasehelper;

  Database? db;

  FoodDTO food = const FoodDTO(name: "Test", amount: 0, entryId: 1);

  sqfliteFfiInit();
  setUp(() async {
    mockDatabasehelper = MockDatabaseHelper();
    datasource = FoodDatasourceImpl(mockDatabasehelper);
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  });

  tearDown(() async {
    await db?.close();
    return Future;
  });

  group('add food to database', () {
    test('should add the food and return the id of it', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);

      // act
      int result = await datasource.insert(food);
      // assert

      expect(result, 1);
      List<Map<String, dynamic>> query =
          await db!.query(FoodDatasourceImpl.tableName);
      expect(query.length, 1);

      verify(() => mockDatabasehelper.database);
      expect(FoodDTO.fromMap(query.first),
          equals(food));
    });
  });

  group('get foods from database', () {
    test('should return all foods for meal ID', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      await datasource
          .insert(food);
      // act
      List<FoodDTO> result = await datasource.getForEntry(1);
      // assert

      expect(result.length, 1);

      verify(() => mockDatabasehelper.database);
      expect(result.first,
          equals(food));
    });

    test('should return no foods for meal ID', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      await datasource
          .insert(food);
      // act
      List<FoodDTO> result = await datasource.getForEntry(0);
      // assert

      expect(result.length, 0);

      verify(() => mockDatabasehelper.database);
      expect(result, equals([]));
    });
  });

  group('delete food from database', () {
    test('should delete the food and return the number of changes', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      int id = await datasource
          .insert(food);
      // act
      int result = await datasource.delete(id);
      // assert

      List<Map<String, dynamic>> query =
          await db!.query(FoodDatasourceImpl.tableName);
      expect(query.length, 0);
      verify(() => mockDatabasehelper.database);
      expect(result, 1);
    });

    test('should not delete any food and return 0', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      await datasource
          .insert(food);
      // act
      int result = await datasource.delete(0);
      // assert

      List<Map<String, dynamic>> query =
          await db!.query(FoodDatasourceImpl.tableName);
      expect(query.length, 1);
      verify(() => mockDatabasehelper.database);
      expect(result, 0);
    });
  });
}
