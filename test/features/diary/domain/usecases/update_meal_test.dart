import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';
import 'package:food_diary/features/diary/domain/usecases/update_meal.dart';
import 'package:food_diary/features/diary/domain/usecases/usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockMealRepository extends Mock implements MealRepository {}

void main() {
  late UpdateMeal usecase;
  late MockMealRepository mealRepository;

  setUpAll(() {
    mealRepository = MockMealRepository();
    usecase = UpdateMeal(mealRepository);
  });
  group('update meal', () {
    test('should update the given meal and return true', () async {
      Meal meal =
          Meal(dateTime: DateTime.now(), foods: const ["Test1", "Test2"]);
      // arrange
      when(() => mealRepository.updateMeal(meal)).thenAnswer((_) async => true);
      // act
      final result = await usecase(Param(meal));
      // assert
      expect(result, true);
      verify(() => mealRepository.updateMeal(meal));
      verifyNoMoreInteractions(mealRepository);
    });

    test('should not update any meal and return false', () async {
      Meal meal =
          Meal(dateTime: DateTime.now(), foods: const ["Test1", "Test2"]);
      // arrange
      when(() => mealRepository.updateMeal(meal)).thenAnswer((_) async => false);
      // act
      final result = await usecase(Param(meal));
      // assert
      expect(result, false);
      verify(() => mealRepository.updateMeal(meal));
      verifyNoMoreInteractions(mealRepository);
    });
  });
}
