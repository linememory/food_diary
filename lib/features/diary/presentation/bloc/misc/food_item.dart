import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';

class FoodItem extends Equatable {
  final String name;
  final Amount amount;

  const FoodItem(this.name, this.amount);
  FoodItem.from(FoodItem item)
      : name = item.name,
        amount = item.amount;

  @override
  List<Object?> get props => [name, amount];
}
