import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';
import 'package:food_diary/features/diary/domain/usecases/usecase.dart';

class AddMeal extends Usecase<bool, Meal> {
  final MealRepository mealRepository;

  AddMeal(this.mealRepository);

  @override
  Future<bool> call(Param params) async {
    return await mealRepository.addMeal(params.get["meal"]);
  }
}
