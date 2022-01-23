import 'package:food_diary/features/diary/data/datasources/meal_datasource.dart';
import 'package:food_diary/features/diary/data/models/meal_dto.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';

class MealRepositoryImpl implements MealRepository {
  MealDatasource datasource;

  MealRepositoryImpl(this.datasource);

  @override
  Future<List<Meal>> getAllMeals() async {
    return (await datasource.getAllMeals())
        .map((e) => e.toMealEntity())
        .toList();
  }

  @override
  Future<bool> addMeal(Meal meal) async {
    MealDTO mealDto = MealDTO.fromMealEntity(meal);
    return await datasource.addMeal(mealDto) == 0 ? false : true;
  }

  @override
  Future<bool> deleteMeal(int id) async {
    return await datasource.deleteMeal(id) == 0 ? false : true;
  }

  @override
  Future<bool> updateMeal(Meal meal) async {
    MealDTO mealDto = MealDTO.fromMealEntity(meal);
    return await datasource.updateMeal(mealDto) == 0 ? false : true;
  }
}
