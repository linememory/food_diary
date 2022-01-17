import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockMealRepository extends Mock implements MealRepository {}

void main() {
  late DiaryFacadeService diaryFacadeService;
  late MockMealRepository mealRepository;

  setUpAll(() {
    mealRepository = MockMealRepository();
    diaryFacadeService = DiaryFacadeService(mealRepository);
  });

  group('get all meals', () {
    test("should return a list with all meals", () async {
      Meal meal =
          Meal(dateTime: DateTime.now(), foods: const ["Test1", "Test2"]);
      // arrange
      when(() => mealRepository.getAllMeals()).thenAnswer((_) async => [meal]);
      // act
      final result = await diaryFacadeService.getAllMeals();
      // assert
      expect(result, [meal]);
      verify(() => mealRepository.getAllMeals());
      verifyNoMoreInteractions(mealRepository);
    });

    test("should return an empty list", () async {
      // arrange
      when(() => mealRepository.getAllMeals()).thenAnswer((_) async => []);
      // act
      final result = await diaryFacadeService.getAllMeals();
      // assert
      expect(result, []);
      verify(() => mealRepository.getAllMeals());
      verifyNoMoreInteractions(mealRepository);
    });
  });

  group('add meal', () {
    test("should add the given meal and return true", () async {
      Meal meal =
          Meal(dateTime: DateTime.now(), foods: const ["Test1", "Test2"]);
      // arrange
      when(() => mealRepository.addMeal(meal)).thenAnswer((_) async => true);
      // act
      final result = await diaryFacadeService.addMeal(meal);
      // assert
      expect(result, true);
      verify(() => mealRepository.addMeal(meal));
      verifyNoMoreInteractions(mealRepository);
    });
  });

  group('update meal', () {
    test('should update the given meal and return true', () async {
      Meal meal =
          Meal(dateTime: DateTime.now(), foods: const ["Test1", "Test2"]);
      // arrange
      when(() => mealRepository.updateMeal(meal)).thenAnswer((_) async => true);
      // act
      final result = await diaryFacadeService.updateMeal(meal);
      // assert
      expect(result, true);
      verify(() => mealRepository.updateMeal(meal));
      verifyNoMoreInteractions(mealRepository);
    });

    test('should not update any meal and return false', () async {
      Meal meal =
          Meal(dateTime: DateTime.now(), foods: const ["Test1", "Test2"]);
      // arrange
      when(() => mealRepository.updateMeal(meal))
          .thenAnswer((_) async => false);
      // act
      final result = await diaryFacadeService.updateMeal(meal);
      // assert
      expect(result, false);
      verify(() => mealRepository.updateMeal(meal));
      verifyNoMoreInteractions(mealRepository);
    });
  });

  group('delete meal', () {
    test('should delete the given meal and return true', () async {
      Meal meal =
          Meal(dateTime: DateTime.now(), foods: const ["Test1", "Test2"]);
      // arrange
      when(() => mealRepository.deleteMeal(meal.dateTime))
          .thenAnswer((_) async => true);
      // act
      final result = await diaryFacadeService.deleteMeal(meal.dateTime);
      // assert
      expect(result, true);
      verify(() => mealRepository.deleteMeal(meal.dateTime));
      verifyNoMoreInteractions(mealRepository);
    });

    test('should not delete any meal and return false', () async {
      Meal meal =
          Meal(dateTime: DateTime.now(), foods: const ["Test1", "Test2"]);
      // arrange
      when(() => mealRepository.deleteMeal(meal.dateTime))
          .thenAnswer((_) async => false);
      // act
      final result = await diaryFacadeService.deleteMeal(meal.dateTime);
      // assert
      expect(result, false);
      verify(() => mealRepository.deleteMeal(meal.dateTime));
      verifyNoMoreInteractions(mealRepository);
    });
  });
}
