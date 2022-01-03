import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';
import 'package:food_diary/features/diary/domain/usecases/add_meal.dart';
import 'package:food_diary/features/diary/domain/usecases/usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockMealRepository extends Mock implements MealRepository {}

void main() {
  late AddMeal usecase;
  late MockMealRepository mealRepository;

  setUpAll(() {
    mealRepository = MockMealRepository();
    usecase = AddMeal(mealRepository);
  });

  group('add meal', () {
    test("should add the given meal and return true", () async {
      Meal meal =
          Meal(dateTime: DateTime.now(), foods: const ["Test1", "Test2"]);
      // arrange
      when(() => mealRepository.addMeal(meal)).thenAnswer((_) async => true);
      // act
      final result = await usecase(Param({"meal": meal}));
      // assert
      expect(result, true);
      verify(() => mealRepository.addMeal(meal));
      verifyNoMoreInteractions(mealRepository);
    });
  });
}
