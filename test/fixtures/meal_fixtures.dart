import 'package:food_diary/features/diary/data/models/food_model.dart';
import 'package:food_diary/features/diary/data/models/meal_model.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';

class MealFixture {
  static final List<FoodModel> _foods = [
    const FoodModel(name: "Food 1", amount: Amount.small),
    const FoodModel(name: "Food 2", amount: Amount.medium),
    const FoodModel(name: "Food 3", amount: Amount.high)
  ];
  static DateTime _currentDate = DateTime(2022, 1, 1, 8);
  static final List<MealModel> _meals = [
    MealModel(dateTime: _currentDate, foods: List<FoodModel>.from(_foods)),
  ];

  static MealModel meal() {
    return _meals.first;
  }

  static List<MealModel> meals(int amount) {
    while (_meals.length < amount) {
      _currentDate = _currentDate.add(const Duration(days: 1));
      _meals.add(MealModel(
          dateTime: _currentDate, foods: List<FoodModel>.from(_foods)));
    }
    return _meals.sublist(0, amount);
  }

  static Map<String, dynamic> mealMap() {
    return {
      'date_time': meal().dateTime.microsecondsSinceEpoch,
      //'foods': _foods.map((e) => e.toMap()).toList()
    };
  }

  static List<Map<String, dynamic>> foodMap() {
    return _foods.map((e) => e.toMap()).toList();
  }
}
