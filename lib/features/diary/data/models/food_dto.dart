import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';

class FoodDTO extends Equatable {
  final int? id;
  final String name;
  final int amount;
  final int? entryId;

  const FoodDTO({
    this.id,
    required this.name,
    required this.amount,
    required this.entryId,
  });

  FoodDTO copyWith({
    int? id,
    String? name,
    int? amount,
    int? entryId,
  }) {
    return FoodDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      entryId: entryId ?? this.entryId,
    );
  }

  FoodDTO.fromEntity({
    required this.entryId,
    required Food food,
  })  : id = null,
        name = food.name,
        amount = food.amount.index;

  Food toEntity() {
    return Food(name: name, amount: Amount.values[amount]);
  }

  Map<String, dynamic> toMap({int? entryId}) {
    return {
      'name': name,
      'amount': amount,
      'entry_id': entryId ?? this.entryId,
    };
  }

  factory FoodDTO.fromMap(Map<String, dynamic> map) {
    return FoodDTO(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      entryId: map['entry_id'],
    );
  }

  @override
  String toString() =>
      'FoodDTO(id: $id, name: $name, amount: $amount, entryId: $entryId)';

  @override
  List<Object?> get props => [name, amount, entryId];
}
