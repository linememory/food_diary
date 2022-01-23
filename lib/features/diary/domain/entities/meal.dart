import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';

class Meal extends Equatable {
  final int? id;
  final DateTime dateTime;
  final List<Food> foods;

  const Meal({
    this.id = -1,
    required this.dateTime,
    required this.foods,
  });

  Meal.from(Meal meal)
      : id = meal.id,
        dateTime = meal.dateTime,
        foods = meal.foods.map((e) => Food.from(e)).toList();

  Meal copyWith({
    int? id,
    DateTime? dateTime,
    List<Food>? foods,
  }) {
    return Meal(
        id: id ?? this.id,
        dateTime: dateTime ?? this.dateTime,
        foods: foods?.map((e) => e.copyWith()).toList() ??
            this.foods.map((e) => e.copyWith()).toList());
  }

  @override
  List<Object?> get props => [id, dateTime, foods];
}
