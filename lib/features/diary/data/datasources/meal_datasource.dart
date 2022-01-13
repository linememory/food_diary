import 'package:food_diary/core/database/database_helper.dart';
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
  Future<int> addMeal(MealModel mealToAdd) async {
    Database db = await _databaseHelper.database;

    final query = await db.query(DatabaseHelper.mealTableName,
        where: '${DatabaseHelper.mealDateTimeColumn} = ?',
        whereArgs: [mealToAdd.dateTime.microsecondsSinceEpoch]);
    if (query.isEmpty) {
      return await db.insert(DatabaseHelper.mealTableName, mealToAdd.toMap());
    } else {
      MealModel mealToUpdate = MealModel.fromMap(query.first);
      mealToUpdate.addFood(mealToAdd.foods);
      updateMeal(mealToUpdate);
      return await Future.value(
          query.first[DatabaseHelper.mealIdColumn] as int);
    }
  }

  @override
  Future<int> deleteMeal(DateTime dateTime) async {
    Database db = await _databaseHelper.database;

    return await db.delete(DatabaseHelper.mealTableName,
        where: '${DatabaseHelper.mealDateTimeColumn} = ?',
        whereArgs: [dateTime.microsecondsSinceEpoch]);
  }

  @override
  Future<List<MealModel>> getAllMeals() async {
    Database db = await _databaseHelper.database;
    List<Map<String, dynamic>> result =
        await db.query(DatabaseHelper.mealTableName);
    return result.map((item) => MealModel.fromMap(item)).toList();
  }

  @override
  Future<int> updateMeal(MealModel mealToUpdate) async {
    Database db = await _databaseHelper.database;
    return db.update(DatabaseHelper.mealTableName, mealToUpdate.toMap(),
        where: '${DatabaseHelper.mealDateTimeColumn} = ?',
        whereArgs: [mealToUpdate.dateTime.microsecondsSinceEpoch]);
  }
}
