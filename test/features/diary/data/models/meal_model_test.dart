import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/data/models/meal_model.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';

import '../../../../fixtures/meal_fixtures.dart';


void main() {
  group('MealModel test', () {
    test('should be a subclass of Meal entity', () {
      // assert
      expect(MealFixture.meal(), isA<Meal>());
    });

    test('should return a valid MealModel from a map', () {
      var mealModelFromMap = MealModel.fromMap(MealFixture.mealMap());
      // assert
      expect(mealModelFromMap, MealFixture.meal());
    });

    test('should return a valid map from a MealModel', () {
      var map = MealFixture.meal().toMap();
      // assert
      expect(map, MealFixture.mealMap());
    });
  });
}
