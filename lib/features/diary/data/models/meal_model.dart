import 'package:food_diary/features/diary/domain/entities/meal.dart';

class MealModel extends Meal {
  const MealModel({
    required DateTime dateTime,
    required List<String> foods,
  }) : super(dateTime: dateTime, foods: foods);

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
        dateTime: DateTime.fromMicrosecondsSinceEpoch(map['date_time']),
        foods: (map['foods'] as String).split(';'));
  }

  Map<String, dynamic> toMap() {
    return {
      'date_time': dateTime.microsecondsSinceEpoch,
      'foods': foods.join(';')
    };
  }

  void addFood(List<String> foodToAdd) {
    foods.addAll(foodToAdd);
  }
}
