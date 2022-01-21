import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';

class MealFormFoodItem extends Equatable {
  final int id;
  final String name;
  final Amount amount;

  const MealFormFoodItem(this.id, this.name, this.amount);
  MealFormFoodItem.from(MealFormFoodItem item)
      : id = item.id,
        name = item.name,
        amount = item.amount;

  @override
  List<Object?> get props => [id, name, amount];
}
