import 'package:food_diary/features/diary/domain/value_objects/food.dart';

class FoodModel extends Food {
  const FoodModel({required String name, required Amount amount})
      : super(name: name, amount: amount);

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      name: map['name'],
      amount: (Amount.values[map['amount']]),
    );
  }

  Map<String, dynamic> toMap({int id = -1}) {
    return {
      'name': name,
      'amount': amount.index,
      'meal_id': id,
    };
  }

  FoodModel.from(Food food) : super(name: food.name, amount: food.amount);
}
