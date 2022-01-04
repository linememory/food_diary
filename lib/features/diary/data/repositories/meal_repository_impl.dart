import 'package:food_diary/features/diary/data/datasources/meal_datasource.dart';
import 'package:food_diary/features/diary/data/models/meal_model.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';

class MealRepositoryImpl implements MealRepository {
  MealDatasource datasource;

  MealRepositoryImpl(this.datasource);

  @override
  Future<List<Meal>> getAllMeals() async {
    return await datasource.getAllMeals();
  }

  @override
  Future<bool> addMeal(Meal meal) async {
    return await datasource.addMeal(meal as MealModel) == 0 ? false : true;
  }

  @override
  Future<bool> deleteMeal(Meal meal) async {
    return await datasource.deleteMeal(meal as MealModel) == 0 ? false : true;
  }

  @override
  Future<bool> updateMeal(Meal meal) async {
    return await datasource.updateMeal(meal as MealModel) == 0 ? false : true;
  }
}
