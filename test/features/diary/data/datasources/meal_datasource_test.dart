import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/datasources/meal_datasource.dart';
import 'package:food_diary/features/diary/data/models/food_model.dart';
import 'package:food_diary/features/diary/data/models/meal_model.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
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

    await db!.execute('''CREATE TABLE meals(
          _id INTEGER PRIMARY KEY AUTOINCREMENT, 
          date_time INTEGER NOT NULL
          )''');
    await db!.execute('''CREATE TABLE foods (
          _id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT NOT NULL, 
          amount INTEGER NOT NULL,
          meal_id INTEGER NOT NULL
          )''');
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
      expect(query.length, 1);
      List<Map<String, dynamic>> foodQuery = await db!.query(
          DatabaseHelper.foodTableName,
          where: 'meal_id = ?',
          whereArgs: [query.first['_id']]);
      expect(foodQuery.length, 3);
      Map<String, dynamic> mealMap = Map.from(query.first);
      mealMap['foods'] = foodQuery;

      verify(() => mockDatabasehelper.database);
      expect(MealModel.fromMap(mealMap), equals(MealFixture.meal()));
      expect(result, 1);
    });

    test('should add only the foods to the already existing meal', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      List<MealModel> mealsToAdd = MealFixture.meals(2);
      await datasource.addMeal(mealsToAdd[0]);
      await datasource.addMeal(mealsToAdd[1]);
      MealModel mealToUpdate =
          MealModel(dateTime: mealsToAdd[1].dateTime, foods: const [
        FoodModel(name: 'New food 1', amount: Amount.small),
        FoodModel(name: 'New food 2', amount: Amount.small),
        FoodModel(name: 'New food 3', amount: Amount.small)
      ]);
      // act
      int result = await datasource.addMeal(mealToUpdate);
      // assert
      expect(result, 2);
      List<Map<String, dynamic>> query =
          await db!.query(DatabaseHelper.mealTableName);
      verify(() => mockDatabasehelper.database);
      expect(query.length, 2);
      var foods = await db!.query(DatabaseHelper.foodTableName,
          where: 'meal_id = ?', whereArgs: [query.last['_id']]);
      Map<String, dynamic> meal = Map.from(query.last);
      meal['foods'] = foods;
      MealModel mealsAfterAdd = MealModel.fromMap(meal);

      expect(mealsAfterAdd, equals(mealToUpdate));
    });
  });

  group('get all meals from database', () {
    test('should return a list of all meals in the database', () async {
      // arrange

      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);

      List<MealModel> meals = MealFixture.meals(2);

      //await db!.insert('meals', MealFixture.mealMap());
      await datasource.addMeal(meals[0]);
      await datasource.addMeal(meals[1]);

      // act
      List<MealModel> result = await datasource.getAllMeals();
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result.length, 2);
      expect(result, equals(meals));
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
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);

      List<MealModel> mealsToAdd = MealFixture.meals(2);
      await datasource.addMeal(mealsToAdd[0]);
      await datasource.addMeal(mealsToAdd[1]);

      // act
      int result = await datasource.deleteMeal(mealsToAdd[0].dateTime);
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result, 1);
      List<MealModel> meals = await datasource.getAllMeals();

      expect(meals.length, 1);
      expect(meals, equals([mealsToAdd[1]]));
    });

    test('should do anything on empty database', () async {
      // arrange

      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      // act
      int result = await datasource.deleteMeal(MealFixture.meal().dateTime);
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result, 0);
      List meals = await db!.query('meals');
      expect(meals.isEmpty, true);
    });

    test('should not delete anything with given meal wich is not in database',
        () async {
      // arrange

      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      List<MealModel> mealsToAdd = MealFixture.meals(3);
      await datasource.addMeal(mealsToAdd[0]);
      await datasource.addMeal(mealsToAdd[1]);

      // act
      int result = await datasource.deleteMeal(mealsToAdd[2].dateTime);
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result, 0);
      List<MealModel> meals = await datasource.getAllMeals();
      expect(meals.length, 2);
      expect(meals, equals([mealsToAdd[0], mealsToAdd[1]]));
    });
  });

  group("update meal", () {
    test('should update the given meal', () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      List<MealModel> mealsToAdd = MealFixture.meals(2);
      await datasource.addMeal(mealsToAdd[0]);
      await datasource.addMeal(mealsToAdd[1]);
      List<MealModel> mealsAfterUpdate = mealsToAdd;
      MealModel mealToUpdate =
          MealModel(dateTime: mealsToAdd.first.dateTime, foods: const [
        FoodModel(name: 'Changed food 1', amount: Amount.small),
        FoodModel(name: 'Changed food 2', amount: Amount.small),
        FoodModel(name: 'Changed food 2', amount: Amount.small)
      ]);
      mealsAfterUpdate[0] = mealToUpdate;
      // act
      var result = await datasource.updateMeal(mealToUpdate);
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result, 1);
      List meals = await datasource.getAllMeals();
      expect(meals.isNotEmpty, true);
      expect(meals, mealsAfterUpdate);
    });

    test(
        'should not update anything with the given meal wich is not in database',
        () async {
      // arrange
      when(() => mockDatabasehelper.database)
          .thenAnswer((invocation) async => db!);
      List<MealModel> mealsToAdd = MealFixture.meals(3);
      await datasource.addMeal(mealsToAdd[0]);
      await datasource.addMeal(mealsToAdd[1]);

      MealModel mealToUpdate =
          MealModel(dateTime: mealsToAdd.last.dateTime, foods: const [
        FoodModel(name: 'Changed food 1', amount: Amount.small),
        FoodModel(name: 'Changed food 2', amount: Amount.small),
        FoodModel(name: 'Changed food 2', amount: Amount.small)
      ]);

      // act
      var result = await datasource.updateMeal(mealToUpdate);
      // assert
      verify(() => mockDatabasehelper.database);
      expect(result, 0);
      List<MealModel> meals = await datasource.getAllMeals();
      expect(meals.isNotEmpty, true);
      expect(meals, mealsToAdd..removeLast());
    });
  });
}
