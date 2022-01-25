import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';

class BowelMovementDTO extends Equatable {
  final int? id;
  final int stoolType;
  final String note;
  final int eventId;
  const BowelMovementDTO({
    this.id,
    required this.stoolType,
    required this.note,
    required this.eventId,
  });

  BowelMovementDTO copyWith({
    int? id,
    int? stoolType,
    String? note,
    int? eventId,
  }) {
    return BowelMovementDTO(
      id: id ?? this.id,
      stoolType: stoolType ?? this.stoolType,
      note: note ?? this.note,
      eventId: eventId ?? this.eventId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stool_type': stoolType,
      'note': note,
      'event_id': eventId,
    };
  }

  factory BowelMovementDTO.fromMap(Map<String, dynamic> map) {
    return BowelMovementDTO(
      id: map['id']?.toInt(),
      stoolType: map['stool_type']?.toInt() ?? 0,
      note: map['note'] ?? '',
      eventId: map['event_id']?.toInt() ?? 0,
    );
  }

  BowelMovementDTO.fromBowelMovementEntity({
    required this.eventId,
    required BowelMovement bowelMovement,
  })  : note = bowelMovement.note,
        stoolType = bowelMovement.stoolType.index,
        id = null;

  BowelMovement toBowelMovementEntity() {
    return BowelMovement(note: note, stoolType: StoolType.values[stoolType]);
  }

  @override
  String toString() {
    return 'BowelMovementDTO(id: $id, type: $stoolType, note: $note, eventId: $eventId)';
  }

  @override
  List<Object?> get props => [id, stoolType, note, eventId];
}
