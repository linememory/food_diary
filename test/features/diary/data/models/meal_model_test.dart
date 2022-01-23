import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/data/models/meal_dto.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';

import '../../../../fixtures/meal_fixtures.dart';

void main() {
  group('MealModel test', () {
    test('should return a valid MealModel from a map', () {
      var mealModelFromMap = MealDTO.fromMap(
          MealFixture.mealMap()..addAll({'foods': MealFixture.foodMap()}));
      // assert
      expect(mealModelFromMap, MealDTO.fromMealEntity(MealFixture.meal()));
    });

    test('should return a valid map from a MealModel', () {
      var map = MealDTO.fromMealEntity(MealFixture.meal()).toMap();
      // assert
      expect(map, MealFixture.mealMap());
    });
  });
}
