import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';

class BowelMovementDTO extends Equatable {
  final int? id;
  final int stoolType;
  final String note;
  final int entryId;
  const BowelMovementDTO({
    this.id,
    required this.stoolType,
    required this.note,
    required this.entryId,
  });

  BowelMovementDTO copyWith({
    int? id,
    int? stoolType,
    String? note,
    int? entryId,
  }) {
    return BowelMovementDTO(
      id: id ?? this.id,
      stoolType: stoolType ?? this.stoolType,
      note: note ?? this.note,
      entryId: entryId ?? this.entryId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stool_type': stoolType,
      'note': note,
      'entry_id': entryId,
    };
  }

  factory BowelMovementDTO.fromMap(Map<String, dynamic> map) {
    return BowelMovementDTO(
      id: map['id'],
      stoolType: map['stool_type'] ?? 0,
      note: map['note'] ?? '',
      entryId: map['entry_id'] ?? 0,
    );
  }

  BowelMovementDTO.fromEntity({
    required this.entryId,
    required BowelMovement bowelMovement,
  })  : note = bowelMovement.note,
        stoolType = bowelMovement.stoolType.index,
        id = null;

  BowelMovement toEntity() {
    return BowelMovement(note: note, stoolType: StoolType.values[stoolType]);
  }

  @override
  String toString() {
    return 'BowelMovementDTO(id: $id, type: $stoolType, note: $note, entryId: $entryId)';
  }

  @override
  List<Object?> get props => [stoolType, note, entryId];
}
