import 'package:food_diary/features/diary/domain/entities/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> getAllMeals();
  Future<bool> addMeal(Meal meal);
  Future<bool> deleteMeal(Meal meal);
  Future<bool> updateMeal(Meal meal);
}
