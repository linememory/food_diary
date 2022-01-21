import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/data/models/food_model.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';

void main() {
  FoodModel foodModel = const FoodModel(name: "Test", amount: Amount.small);
  Map<String, dynamic> foodMap = const {
    'name': "Test",
    'amount': 0,
    'meal_id': -1
  };

  group('FoodModel test', () {
    test('should be a subclass of Food entity', () {
      // assert
      expect(foodModel, isA<Food>());
    });

    test('should return a valid FoodModel from a map', () {
      var mealModelFromMap = FoodModel.fromMap(foodMap);
      // assert
      expect(mealModelFromMap, foodModel);
    });

    test('should return a valid map from a MealModel', () {
      var map = foodModel.toMap();
      // assert
      expect(map, foodMap);
    });
  });
}
