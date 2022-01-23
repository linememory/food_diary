import 'package:equatable/equatable.dart';

enum Amount {
  small,
  medium,
  high,
}

extension ParseToString on Amount {
  String get name => toString().split('.').last;
}

class Food extends Equatable {
  const Food({
    required this.name,
    required this.amount,
  });

  Food.from(Food food)
      : name = food.name,
        amount = food.amount;

  final String name;
  final Amount amount;

  Food copyWith({
    String? name,
    Amount? amount,
  }) {
    return Food(
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [name, amount];
}
