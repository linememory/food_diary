import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';

class BowelMovementEntry extends DiaryEntry {
  final BowelMovement bowelMovement;

  const BowelMovementEntry({
    int? id,
    required DateTime dateTime,
    required this.bowelMovement,
  }) : super(id: id, dateTime: dateTime);

  BowelMovementEntry.from(BowelMovementEntry diaryEntry)
      : bowelMovement = diaryEntry.bowelMovement,
        super(id: diaryEntry.id, dateTime: diaryEntry.dateTime);

  @override
  BowelMovementEntry copyWith({
    int? id,
    DateTime? dateTime,
    BowelMovement? bowelMovement,
  }) {
    return BowelMovementEntry(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      bowelMovement: bowelMovement ?? this.bowelMovement,
    );
  }

  @override
  List<Object?> get props => super.props..add(bowelMovement);
}
