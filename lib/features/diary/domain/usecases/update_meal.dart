import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';
import 'package:food_diary/features/diary/domain/usecases/usecase.dart';

class UpdateMeal extends Usecase<bool, Meal> {
  final MealRepository mealRepository;

  UpdateMeal(this.mealRepository);

  @override
  Future<bool> call(Param params) async {
    return await mealRepository.updateMeal(params.get["meal"]);
  }
}
