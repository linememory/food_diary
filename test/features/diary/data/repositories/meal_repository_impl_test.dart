import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/data/datasources/meal_datasource.dart';
import 'package:food_diary/features/diary/data/repositories/meal_repository_impl.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/meal_fixtures.dart';

class MockMealDatasource extends Mock implements MealDatasource {}

void main() {
  late MealRepositoryImpl mealRepository;
  late MockMealDatasource mealDatasource;

  setUp(() {
    mealDatasource = MockMealDatasource();
    mealRepository = MealRepositoryImpl(mealDatasource);
  });

  group('get all meals', () {
    test('should return a list of all Meals', () async {
      // arrange
      when(() => mealDatasource.getAllMeals())
          .thenAnswer((_) async => [MealFixture.meal()]);
      // act
      final List<Meal> result = await mealRepository.getAllMeals();
      // assert
      verify(mealDatasource.getAllMeals);
      expect(result, equals([MealFixture.meal()]));
    });

    test('should return an empty list', () async {
      // arrange
      when(() => mealDatasource.getAllMeals()).thenAnswer((_) async => []);
      // act
      final List<Meal> result = await mealRepository.getAllMeals();
      // assert
      verify(mealDatasource.getAllMeals);
      expect(result.isEmpty, true);
    });
  });

  group('add meal', () {
    test('should add the given Meal', () async {
      // arrange
      when(() => mealDatasource.addMeal(MealFixture.meal()))
          .thenAnswer((_) async => 1);
      // act
      final result = await mealRepository.addMeal(MealFixture.meal());
      // assert
      verify(() => mealDatasource.addMeal(MealFixture.meal()));
      expect(result, true);
    });
  });

  group('update meal', () {
    test('should update the given meal', () async {
      // arrange
      when(() => mealDatasource.updateMeal(MealFixture.meal()))
          .thenAnswer((_) async => 1);
      // act
      final result = await mealRepository.updateMeal(MealFixture.meal());
      // assert
      verify(() => mealDatasource.updateMeal(MealFixture.meal()));
      expect(result, true);
    });
  });

  group('delete meal', () {
    test('should delete the given Meal', () async {
      // arrange
      when(() => mealDatasource.deleteMeal(MealFixture.meal()))
          .thenAnswer((_) async => 1);
      // act
      final result = await mealRepository.deleteMeal(MealFixture.meal());
      // assert
      verify(() => mealDatasource.deleteMeal(MealFixture.meal()));
      expect(result, true);
    });
  });
}
