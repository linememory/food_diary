import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';
import 'package:food_diary/features/diary/domain/usecases/get_all_meals.dart';
import 'package:food_diary/features/diary/domain/usecases/usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockMealRepository extends Mock implements MealRepository {}

void main() {
  late GetAllMeals usecase;
  late MockMealRepository mealRepository;

  setUpAll(() {
    mealRepository = MockMealRepository();
    usecase = GetAllMeals(mealRepository);
  });

  group('get all meals', () {
    test("should return a list with all meals", () async {
      Meal meal =
          Meal(dateTime: DateTime.now(), foods: const ["Test1", "Test2"]);
      // arrange
      when(() => mealRepository.getAllMeals()).thenAnswer((_) async => [meal]);
      // act
      final result = await usecase(Param.noParam());
      // assert
      expect(result, [meal]);
      verify(() => mealRepository.getAllMeals());
      verifyNoMoreInteractions(mealRepository);
    });

    test("should return an empty list", () async {
      // arrange
      when(() => mealRepository.getAllMeals()).thenAnswer((_) async => []);
      // act
      final result = await usecase(Param.noParam());
      // assert
      expect(result, []);
      verify(() => mealRepository.getAllMeals());
      verifyNoMoreInteractions(mealRepository);
    });
  });
}
