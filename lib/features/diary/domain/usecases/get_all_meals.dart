import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';
import 'package:food_diary/features/diary/domain/usecases/usecase.dart';

class GetAllMeals implements Usecase<List<Meal>, Param> {
  final MealRepository mealRepository;

  GetAllMeals(this.mealRepository);

  @override
  Future<List<Meal>> call(Param params) async {
    return await mealRepository.getAllMeals();
  }
}



