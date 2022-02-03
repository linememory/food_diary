import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/data/models/food_dto.dart';

void main() {
  FoodDTO foodDto = const FoodDTO(name: "Test", amount: 0, entryId: 0);
  Map<String, dynamic> foodMap = const {
    'id': null,
    'name': "Test",
    'amount': 0,
    'entry_id': 0,
  };

  group('FoodModel test', () {
    test('should return a valid FoodModel from a map', () {
      var mealModelFromMap = FoodDTO.fromMap(foodMap);
      // assert
      expect(mealModelFromMap, foodDto);
    });

    test('should return a valid map from a MealModel', () {
      var map = foodDto.toMap();
      // assert
      var expected = Map.from(foodMap)..remove('id');
      expect(map, expected);
    });
  });
}
