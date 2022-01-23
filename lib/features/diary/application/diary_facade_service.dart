import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';

class DiaryFacadeService {
  DiaryFacadeService(this.mealRepository);

  final MealRepository mealRepository;

  Future<List<Meal>> getAllMeals() async {
    return await mealRepository.getAllMeals();
  }

  Future<bool> addMeal(Meal meal) async {
    return await mealRepository.addMeal(meal);
  }

  Future<bool> updateMeal(Meal meal) async {
    return await mealRepository.updateMeal(meal);
  }

  Future<bool> deleteMeal(int id) async {
    return await mealRepository.deleteMeal(id);
  }
}
