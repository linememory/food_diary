import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';

class MealFormFoodItem extends Equatable {
  //final int id;
  final String name;
  final Amount amount;

  const MealFormFoodItem(this.name, this.amount);
  MealFormFoodItem.from(MealFormFoodItem item)
      : name = item.name,
        amount = item.amount;

  @override
  List<Object?> get props => [name, amount];
}
