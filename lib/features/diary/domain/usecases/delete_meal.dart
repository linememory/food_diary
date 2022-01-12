import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';
import 'package:food_diary/features/diary/domain/usecases/usecase.dart';

class DeleteMeal extends Usecase<bool, DateTime> {
  final MealRepository mealRepository;

  DeleteMeal(this.mealRepository);

  @override
  Future<bool> call(Param param) async {
    return await mealRepository.deleteMeal(param.get);
  }
}