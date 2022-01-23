import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/food_item.dart';

class MealItem extends Equatable {
  final int? id;
  final DateTime dateTime;
  final List<FoodItem> foods;

  const MealItem(this.id, this.dateTime, this.foods);
  MealItem.from(MealItem item)
      : id = item.id,
        dateTime = item.dateTime,
        foods = item.foods;

  MealItem.fromMealEntity(Meal meal)
      : id = meal.id,
        dateTime = meal.dateTime,
        foods =
            meal.foods.map((food) => FoodItem.fromFoodEntity(food)).toList();

  Meal toMealEntity() {
    return Meal(
        id: id,
        dateTime: dateTime,
        foods: foods.map((e) => e.toFoodEntity()).toList());
  }

  @override
  List<Object?> get props => [id, dateTime, foods];
}
