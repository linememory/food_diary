import 'package:food_diary/features/diary/domain/value_objects/food.dart';

class FoodDTO {
  int? id;
  String name;
  Amount amount;
  int? mealId;

  FoodDTO({
    this.id,
    required this.name,
    required this.amount,
    required this.mealId,
  });

  FoodDTO copyWith({
    int? id,
    String? name,
    Amount? amount,
    int? mealId,
  }) {
    return FoodDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      mealId: mealId ?? this.mealId,
    );
  }

  FoodDTO.fromFoodEntity(Food food, this.mealId)
      : name = food.name,
        amount = food.amount;

  Food toFoodEntity() {
    return Food(name: name, amount: amount);
  }

  Map<String, dynamic> toMap({int? mealId}) {
    return {
      'id': id,
      'name': name,
      'amount': amount.index,
      'meal_id': mealId ?? this.mealId,
    };
  }

  factory FoodDTO.fromMap(Map<String, dynamic> map) {
    return FoodDTO(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      amount: Amount.values[map['amount']],
      mealId: map['meal_id'],
    );
  }

  @override
  String toString() =>
      'FoodDTO(id: $id, name: $name, amount: $amount, mealId: $mealId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FoodDTO &&
        other.name == name &&
        other.amount == amount &&
        other.mealId == mealId;
  }

  @override
  int get hashCode => name.hashCode ^ amount.hashCode ^ mealId.hashCode;
}
