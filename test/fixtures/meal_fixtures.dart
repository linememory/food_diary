import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';

class MealFixture {
  static final List<Food> _foods = [
    const Food(name: "Food 1", amount: Amount.small),
    const Food(name: "Food 2", amount: Amount.medium),
    const Food(name: "Food 3", amount: Amount.high)
  ];
  static DateTime _currentDate = DateTime(2022, 1, 1, 8);
  static final List<Meal> _meals = [
    Meal(id: 1, dateTime: _currentDate, foods: List<Food>.from(_foods)),
  ];

  static Meal meal() {
    return _meals.first;
  }

  static List<Meal> meals(int amount) {
    while (_meals.length < amount) {
      _currentDate = _currentDate.add(const Duration(days: 1));
      _meals.add(Meal(
          id: _meals.length + 1,
          dateTime: _currentDate,
          foods: List<Food>.from(_foods)));
    }
    return _meals.sublist(0, amount);
  }

  static Map<String, dynamic> mealMap() {
    return {
      'id': 1,
      'date_time': meal().dateTime.microsecondsSinceEpoch,
      //'foods': _foods.map((e) => e.toMap()).toList()
    };
  }

  static List<Map<String, dynamic>> foodMap() {
    return _foods
        .map((e) => {
              'id': null,
              'name': e.name,
              'amount': e.amount.index,
              'meal_id': 1
            })
        .toList();
  }
}
