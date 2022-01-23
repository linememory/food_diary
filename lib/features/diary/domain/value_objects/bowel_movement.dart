import 'package:equatable/equatable.dart';

enum StoolType {
  type1,
  type2,
  type3,
  type4,
  type5,
  type6,
  type7,
}

extension ParseToString on Type {
  String get name => toString().split('.').last;
}

class BowelMovement extends Equatable {
  const BowelMovement({
    required this.name,
    required this.stoolType,
  });

  BowelMovement.from(BowelMovement food)
      : name = food.name,
        stoolType = food.stoolType;

  final String name;
  final StoolType stoolType;

  BowelMovement copyWith({
    String? name,
    StoolType? stoolType,
  }) {
    return BowelMovement(
      name: name ?? this.name,
      stoolType: stoolType ?? this.stoolType,
    );
  }

  @override
  List<Object?> get props => [name, stoolType];
}
