import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/datasources/meal_datasource.dart';
import 'package:food_diary/features/diary/data/models/meal_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../fixtures/meal_fixtures.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late MealDatasourceImpl datasource;
  late MockDatabaseHelper mockDatabasehelper;

  Database? db;

  sqfliteFfiInit();
  setUp(() async {
    mockDatabasehelper = MockDatabaseHelper();
    datasource = MealDatasourceImpl(mockDatabasehelper);

    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await db!.execute('''
      CREATE TABLE meals (
      _id INTEGER PRIMARY KEY AUTOINCREMENT,
      date_time INTEGER NOT NULL,
      foods TEXT NOT NULL)
      ''');
    return Future;
  });

  tearDown(() async {
    await db?.close();
    return Future;
  });

  group('add meal to database', () {
    test('should add the meal and return the id of it', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      // act
      int result = await datasource.addMeal(MealFixture.meal());
      // assert
      List<Map<String, dynamic>> query =
          await db!.query(DatabaseHelper.mealTableName);
      verify(() => mockDatabasehelper.database);
      expect(query.length, 1);
      expect(MealModel.fromMap(query.first), equals(MealFixture.meal()));
      expect(result, 1);
    });

    test('should add only the foods to the already existing meal', () async {
      // arrange
      List<MealModel> mealsToAdd = MealFixture.meals(2);
      await db!.insert('meals', mealsToAdd[0].toMap());
      await db!.insert('meals', mealsToAdd[1].toMap());
      MealModel mealToUpdate = MealModel(
          dateTime: mealsToAdd[1].dateTime,
          foods: const ['New food 1', 'New food 2', 'New food 2']);
      mealsToAdd[1].addFood(mealToUpdate.foods);
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      // act
      int result = await datasource.addMeal(mealToUpdate);
      // assert
      List<Map<String, dynamic>> query =
          await db!.query(DatabaseHelper.mealTableName);
      verify(() => mockDatabasehelper.database);
      expect(result, 2);
      expect(query.length, 2);
      List<MealModel> mealsAfterAdd =
          query.map((e) => MealModel.fromMap(e)).toList();
      expect(mealsAfterAdd, equals(mealsToAdd));
    });
  });

  group('get all meals from database', () {
    test('should return a list of all meals in the database', () async {
      // arrange

      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);

      await db!.insert('meals', MealFixture.mealMap());

      // act
      List<MealModel> result = await datasource.getAllMeals();
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result.length, 1);
      expect(result, equals([MealFixture.meal()]));
    });

    test('should return a empty list', () async {
      // arrange

      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      // act
      List<MealModel> result = await datasource.getAllMeals();
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result.isEmpty, true);
    });
  });

  group("delete meal from database", () {
    test('should delete the given meal from database', () async {
      // arrange

      List<MealModel> mealsToAdd = MealFixture.meals(2);
      await db!.insert('meals', mealsToAdd[0].toMap());
      await db!.insert('meals', mealsToAdd[1].toMap());

      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      // act
      int result = await datasource.deleteMeal(mealsToAdd[0]);
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result, 1);
      List meals = await db!.query('meals');
      expect(meals.length, 1);
      expect(meals.map((e) => MealModel.fromMap(e)).toList(),
          equals([mealsToAdd[1]]));
    });

    test('should do anything on empty database', () async {
      // arrange

      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      // act
      int result = await datasource.deleteMeal(MealFixture.meal());
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result, 0);
      List meals = await db!.query('meals');
      expect(meals.isEmpty, true);
    });

    test('should not delete anything with given meal wich is not in database',
        () async {
      // arrange

      List<MealModel> mealsToAdd = MealFixture.meals(3);
      await db!.insert('meals', mealsToAdd[0].toMap());
      await db!.insert('meals', mealsToAdd[1].toMap());

      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      // act
      int result = await datasource.deleteMeal(mealsToAdd[2]);
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result, 0);
      List meals = await db!.query('meals');
      expect(meals.length, 2);
      expect(meals.map((e) => MealModel.fromMap(e)).toList(),
          equals([mealsToAdd[0], mealsToAdd[1]]));
    });
  });

  group("update meal", () {
    test('should update the given meal', () async {
      // arrange
      List<MealModel> mealsToAdd = MealFixture.meals(2);
      await db!.insert('meals', mealsToAdd[0].toMap());
      await db!.insert('meals', mealsToAdd[1].toMap());
      List<MealModel> mealsAfterUpdate = mealsToAdd;
      MealModel mealToUpdate = MealModel(
          dateTime: mealsToAdd.first.dateTime,
          foods: const ['Changed food 1', 'Changed food 2', 'Changed food 2']);
      mealsAfterUpdate[0] = mealToUpdate;
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      // act
      var result = await datasource.updateMeal(mealToUpdate);
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result, 1);
      List meals = await db!.query('meals');
      expect(meals.isNotEmpty, true);
      expect(meals.map((e) => MealModel.fromMap(e)), mealsAfterUpdate);
    });

    test(
        'should not update anything with the given meal wich is not in database',
        () async {
      // arrange
      List<MealModel> mealsToAdd = MealFixture.meals(2);
      await db!.insert('meals', mealsToAdd[0].toMap());
      await db!.insert('meals', mealsToAdd[1].toMap());
      MealModel mealToUpdate = MealModel(
          dateTime: DateTime(2022, 1, 1, 1),
          foods: const ['Changed food 1', 'Changed food 2', 'Changed food 2']);

      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      // act
      var result = await datasource.updateMeal(mealToUpdate);
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result, 0);
      List meals = await db!.query('meals');
      expect(meals.isNotEmpty, true);
      expect(meals.map((e) => MealModel.fromMap(e)), mealsToAdd);
    });
  });
}
