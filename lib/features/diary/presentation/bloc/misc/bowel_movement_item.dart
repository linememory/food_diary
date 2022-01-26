import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/entry_item.dart';

class BowelMovementItem extends EntryItem {
  final StoolType type;
  final String note;

  const BowelMovementItem({
    int? id,
    required DateTime dateTime,
    required this.type,
    required this.note,
  }) : super(id: id, dateTime: dateTime);

  BowelMovementItem.from(BowelMovementItem item)
      : type = item.type,
        note = item.note,
        super(id: item.id, dateTime: item.dateTime);

  BowelMovementItem.fromEntity(BowelMovementEntry bowelMovementEntry)
      : type = bowelMovementEntry.bowelMovement.stoolType,
        note = bowelMovementEntry.bowelMovement.note,
        super(id: bowelMovementEntry.id, dateTime: bowelMovementEntry.dateTime);

  @override
  BowelMovementEntry toEntity() {
    return BowelMovementEntry(
        id: id,
        dateTime: dateTime,
        bowelMovement: BowelMovement(note: note, stoolType: type));
  }

  @override
  List<Object?> get props => super.props..addAll([type, note]);
}
