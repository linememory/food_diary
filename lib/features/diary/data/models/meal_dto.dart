import 'package:flutter/foundation.dart';

import 'package:food_diary/features/diary/data/models/food_dto.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';

class MealDTO {
  int? id;
  DateTime dateTime;
  late List<FoodDTO> foods;
  MealDTO({
    this.id = -1,
    required this.dateTime,
    required this.foods,
  });

  MealDTO.fromMealEntity(Meal meal)
      : id = meal.id,
        dateTime = meal.dateTime {
    foods = meal.foods
        .map((food) => FoodDTO.fromFoodEntity(food, meal.id))
        .toList();
  }

  MealDTO copyWith({
    int? id,
    DateTime? dateTime,
    List<FoodDTO>? foods,
  }) {
    return MealDTO(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      foods: foods?.map((food) => food..mealId = id ?? this.id).toList() ??
          this.foods.map((food) => food..mealId = id ?? this.id).toList(),
    );
  }

  Meal toMealEntity() {
    return Meal(
        id: id,
        dateTime: dateTime,
        foods: foods.map((food) => food.toFoodEntity()).toList());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date_time': dateTime.microsecondsSinceEpoch,
      //'foods': foods.map((food) => food.toMap()).toList(),
    };
  }

  factory MealDTO.fromMap(Map<String, dynamic> map) {
    return MealDTO(
      id: map['id']?.toInt() ?? -1,
      dateTime: DateTime.fromMicrosecondsSinceEpoch(map['date_time']),
      foods: List<FoodDTO>.from(
          map['foods']?.map((food) => FoodDTO.fromMap(food)) ?? []),
    );
  }

  @override
  String toString() => 'MealDTO(id: $id, dateTime: $dateTime, foods: $foods)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MealDTO &&
        other.id == id &&
        other.dateTime == dateTime &&
        listEquals(other.foods, foods);
  }

  @override
  int get hashCode => id.hashCode ^ dateTime.hashCode ^ foods.hashCode;
}
