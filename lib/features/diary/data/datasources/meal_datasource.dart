import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/models/food_model.dart';
import 'package:food_diary/features/diary/data/models/meal_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class MealDatasource {
  Future<List<MealModel>> getAllMeals();
  Future<int> addMeal(MealModel mealToAdd);
  Future<int> deleteMeal(DateTime dateTime);
  Future<int> updateMeal(MealModel mealToUpdate);
}

class MealDatasourceImpl implements MealDatasource {
  final DatabaseHelper _databaseHelper;

  MealDatasourceImpl(this._databaseHelper);

  @override
  Future<List<MealModel>> getAllMeals() async {
    Database db = await _databaseHelper.database;
    List<Map<String, dynamic>> result =
        await db.query(DatabaseHelper.mealTableName);
    List<Map<String, dynamic>> meals = [];
    for (var mealResult in result) {
      int id = mealResult[DatabaseHelper.idColumn];
      List<Map<String, dynamic>> foodsQuery = await _getFoodsForMeal(id);
      Map<String, dynamic> meal = Map.from(mealResult)
        ..addAll({'foods': foodsQuery});
      meals.add(meal);
    }
    return meals.map((item) => MealModel.fromMap(item)).toList();
  }

  @override
  Future<int> addMeal(MealModel mealToAdd) async {
    Database db = await _databaseHelper.database;

    final query = await db.query(DatabaseHelper.mealTableName,
        where: '${DatabaseHelper.mealDateTimeColumn} = ?',
        whereArgs: [mealToAdd.dateTime.microsecondsSinceEpoch]);
    if (query.isEmpty) {
      int id = await db.insert(DatabaseHelper.mealTableName, mealToAdd.toMap());
      for (var food in mealToAdd.foods) {
        await db.insert(
            DatabaseHelper.foodTableName, (food as FoodModel).toMap(id: id));
      }
      return 1;
    } else {
      await updateMeal(mealToAdd);
      return await Future.value(query.first[DatabaseHelper.idColumn] as int);
    }
  }

  @override
  Future<int> updateMeal(MealModel mealToUpdate) async {
    Database db = await _databaseHelper.database;

    final query = await db.query(DatabaseHelper.mealTableName,
        where: '${DatabaseHelper.mealDateTimeColumn} = ?',
        whereArgs: [mealToUpdate.dateTime.microsecondsSinceEpoch]);
    if (query.isNotEmpty) {
      int id = query.first[DatabaseHelper.idColumn] as int;

      await _deleteFoods(id);
      for (var food in mealToUpdate.foods) {
        await db.insert(
            DatabaseHelper.foodTableName, (food as FoodModel).toMap(id: id));
      }
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteMeal(DateTime dateTime) async {
    Database db = await _databaseHelper.database;

    final query = await db.query(DatabaseHelper.mealTableName,
        where: '${DatabaseHelper.mealDateTimeColumn} = ?',
        whereArgs: [dateTime.microsecondsSinceEpoch]);
    if (query.isNotEmpty) {
      _deleteFoods(query.first[DatabaseHelper.idColumn] as int);
    }
    return await db.delete(DatabaseHelper.mealTableName,
        where: '${DatabaseHelper.mealDateTimeColumn} = ?',
        whereArgs: [dateTime.microsecondsSinceEpoch]);
  }

  Future _deleteFoods(int mealId) async {
    Database db = await _databaseHelper.database;
    await db.delete(DatabaseHelper.foodTableName,
        where: '${DatabaseHelper.foodMealIdColumn} = ?', whereArgs: [mealId]);
    //
  }

  Future<List<Map<String, dynamic>>> _getFoodsForMeal(int mealId) async {
    Database db = await _databaseHelper.database;
    List<Map<String, dynamic>> foodsQuery = await db.query(
        DatabaseHelper.foodTableName,
        where: '${DatabaseHelper.foodMealIdColumn} = ?',
        whereArgs: [mealId]);
    return foodsQuery;
  }
}
