import 'package:food_diary/features/diary/data/models/meal_model.dart';

class MealFixture {
  static final _foods = ["Food 1", "Food 2", "Food 3"];
  static DateTime _currentDate = DateTime(2022, 1, 1, 8);
  static final List<MealModel> _meals = [
    MealModel(dateTime: _currentDate, foods: List<String>.from(_foods)),
  ];

  static MealModel meal() {
    return _meals.first;
  }

  static List<MealModel> meals(int amount) {
    while (_meals.length < amount) {
      _currentDate = _currentDate.add(const Duration(days: 1));
      _meals.add(
          MealModel(dateTime: _currentDate, foods: List<String>.from(_foods)));
    }
    return _meals.sublist(0, amount);
  }

  static Map<String, dynamic> mealMap() {
    return {
      'date_time': meal().dateTime.microsecondsSinceEpoch,
      'foods': meal().foods.join(';')
    };
  }
}
