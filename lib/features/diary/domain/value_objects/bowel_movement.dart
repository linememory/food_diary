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
  final String note;
  final StoolType stoolType;

  const BowelMovement({
    required this.note,
    required this.stoolType,
  });

  BowelMovement.from(BowelMovement food)
      : note = food.note,
        stoolType = food.stoolType;

  BowelMovement copyWith({
    String? note,
    StoolType? stoolType,
  }) {
    return BowelMovement(
      note: note ?? this.note,
      stoolType: stoolType ?? this.stoolType,
    );
  }

  @override
  List<Object?> get props => [note, stoolType];
}
