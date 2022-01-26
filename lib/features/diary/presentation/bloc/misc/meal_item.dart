import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/entry_item.dart';

class MealItem extends EntryItem {
  final List<FoodItem> foods;

  const MealItem({int? id, required DateTime dateTime, required this.foods})
      : super(id: id, dateTime: dateTime);

  MealItem.from(MealItem item)
      : foods = item.foods,
        super(id: item.id, dateTime: item.dateTime);

  MealItem.fromEntity(MealEntry meal)
      : foods = meal.foods.map((e) => FoodItem.fromEntity(e)).toList(),
        super(id: meal.id, dateTime: meal.dateTime);

  @override
  DiaryEntry toEntity() {
    return MealEntry(
        id: id,
        dateTime: dateTime,
        foods: foods.map((e) => e.toEntity()).toList());
  }

  @override
  List<Object?> get props => super.props..add(foods);
}

class FoodItem extends Equatable {
  final String name;
  final Amount amount;

  const FoodItem({required this.name, required this.amount});
  FoodItem.from(FoodItem item)
      : name = item.name,
        amount = item.amount;

  FoodItem.fromEntity(Food food)
      : name = food.name,
        amount = food.amount;

  Food toEntity() {
    return Food(name: name, amount: amount);
  }

  @override
  List<Object?> get props => [name, amount];
}
