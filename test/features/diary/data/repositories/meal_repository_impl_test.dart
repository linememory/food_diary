import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/data/datasources/meal_datasource.dart';
import 'package:food_diary/features/diary/data/models/meal_dto.dart';
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
      MealDTO mealDto = MealDTO.fromMealEntity(MealFixture.meal());
      when(() => mealDatasource.getAllMeals())
          .thenAnswer((_) async => [mealDto]);
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
      MealDTO mealDto = MealDTO.fromMealEntity(MealFixture.meal());
      when(() => mealDatasource.addMeal(mealDto))
          .thenAnswer((_) async => 1);
      // act
      final result = await mealRepository.addMeal(MealFixture.meal());
      // assert
      verify(() => mealDatasource.addMeal(mealDto));
      expect(result, true);
    });
  });

  group('update meal', () {
    test('should update the given meal', () async {
      // arrange
      MealDTO mealDto = MealDTO.fromMealEntity(MealFixture.meal());
      when(() => mealDatasource.updateMeal(mealDto))
          .thenAnswer((_) async => 1);
      // act
      final result = await mealRepository.updateMeal(MealFixture.meal());
      // assert
      verify(() => mealDatasource.updateMeal(mealDto));
      expect(result, true);
    });
  });

  group('delete meal', () {
    test('should delete the given Meal', () async {
      // arrange
      when(() => mealDatasource.deleteMeal(MealFixture.meal().id!))
          .thenAnswer((_) async => 1);
      // act
      final result = await mealRepository.deleteMeal(MealFixture.meal().id!);
      // assert
      verify(() => mealDatasource.deleteMeal(MealFixture.meal().id!));
      expect(result, true);
    });
  });
}
