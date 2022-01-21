import 'package:food_diary/features/diary/data/models/food_model.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';

class MealModel extends Meal {
  const MealModel({
    int? id,
    required DateTime dateTime,
    required List<FoodModel> foods,
  }) : super(id: id, dateTime: dateTime, foods: foods);

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
      id: map['_id'],
      dateTime: DateTime.fromMicrosecondsSinceEpoch(map['date_time']),
      foods: (map['foods'] as List<Map<String, dynamic>>)
          .map((e) => FoodModel.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date_time': dateTime.microsecondsSinceEpoch,
      //'foods': foods.map((e) => (e as FoodModel).toMap()).toList()
    };
  }

  void addFood(FoodModel foodToAdd) {
    foods.add(foodToAdd);
  }

  static MealModel from(Meal meal) {
    return MealModel(
        id: meal.id,
        dateTime: meal.dateTime,
        foods: List.from(meal.foods.map((e) => FoodModel.from(e))));
  }
}
