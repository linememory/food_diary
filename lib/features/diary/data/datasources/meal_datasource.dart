import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/models/meal_dto.dart';
import 'package:sqflite/sqflite.dart';

abstract class MealDatasource {
  Future<List<MealDTO>> getAllMeals();
  Future<int> addMeal(MealDTO mealToAdd);
  Future<int> deleteMeal(int id);
  Future<int> updateMeal(MealDTO mealToUpdate);
}

class MealDatasourceImpl implements MealDatasource {
  final DatabaseHelper _databaseHelper;

  MealDatasourceImpl(this._databaseHelper);

  @override
  Future<List<MealDTO>> getAllMeals() async {
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
    return meals.map((item) => MealDTO.fromMap(item)).toList();
  }

  @override
  Future<int> addMeal(MealDTO mealToAdd) async {
    Database db = await _databaseHelper.database;

    final query = await db.query(DatabaseHelper.mealTableName,
        where:
            '${DatabaseHelper.idColumn} = ? OR ${DatabaseHelper.mealDateTimeColumn} = ?',
        whereArgs: [mealToAdd.id, mealToAdd.dateTime.microsecondsSinceEpoch]);

    if (query.isEmpty) {
      Map<String, dynamic> mealMap = mealToAdd.toMap()..remove('id');
      int id = await db.insert(DatabaseHelper.mealTableName, mealMap);
      for (var food in mealToAdd.foods) {
        await db.insert(DatabaseHelper.foodTableName, food.toMap(mealId: id));
      }
      return id;
    } else {
      if (query.first[DatabaseHelper.idColumn] == mealToAdd.id) {
        await updateMeal(mealToAdd);
        return await Future.value(query.first[DatabaseHelper.idColumn] as int);
      } else if (query.first[DatabaseHelper.mealDateTimeColumn] ==
          mealToAdd.dateTime.microsecondsSinceEpoch) {
        await updateMeal(MealDTO(
            id: query.first[DatabaseHelper.idColumn] as int,
            dateTime: mealToAdd.dateTime,
            foods: mealToAdd.foods));
        return await Future.value(query.first[DatabaseHelper.idColumn] as int);
      }
    }
    return -1;
  }

  @override
  Future<int> updateMeal(MealDTO mealToUpdate) async {
    if (mealToUpdate.id == null) {
      return 0;
    } else {
      Database db = await _databaseHelper.database;

      final query = await db.query(DatabaseHelper.mealTableName,
          where: '${DatabaseHelper.idColumn} = ?',
          whereArgs: [mealToUpdate.id]);
      if (query.isNotEmpty) {
        int id = query.first[DatabaseHelper.idColumn] as int;

        await _deleteFoods(mealToUpdate.id!);
        for (var food in mealToUpdate.foods) {
          await db.insert(DatabaseHelper.foodTableName, food.toMap(mealId: id));
        }
        return 1;
      }
      return 0;
    }
  }

  @override
  Future<int> deleteMeal(int id) async {
    Database db = await _databaseHelper.database;
    return await db.delete(DatabaseHelper.mealTableName,
        where: '${DatabaseHelper.idColumn} = ?', whereArgs: [id]);
  }

  Future<int> _deleteFoods(int mealId) async {
    Database db = await _databaseHelper.database;
    return await db.delete(DatabaseHelper.foodTableName,
        where: '${DatabaseHelper.foodMealIdColumn} = ?', whereArgs: [mealId]);
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
