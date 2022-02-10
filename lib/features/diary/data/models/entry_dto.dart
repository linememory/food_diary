import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';

class EntryDTO extends Equatable {
  final int? id;
  final DateTime dateTime;
  final EntryType type;
  const EntryDTO({
    this.id,
    required this.dateTime,
    required this.type,
  });

  EntryDTO copyWith({
    int? id,
    DateTime? dateTime,
    EntryType? type,
  }) {
    return EntryDTO(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date_time': dateTime.microsecondsSinceEpoch,
      'type': type.index,
    };
  }

  factory EntryDTO.fromMap(Map<String, dynamic> map) {
    return EntryDTO(
      id: map['id'],
      dateTime: DateTime.fromMicrosecondsSinceEpoch(map['date_time']),
      type: EntryType.values[map['type']],
    );
  }

  EntryDTO.fromEntity(DiaryEntry entry)
      : id = entry.id,
        dateTime = entry.dateTime,
        type = getType(entry);

  @override
  String toString() => 'EntryDTO(id: $id, dateTime: $dateTime)';

  @override
  List<Object?> get props => [id, dateTime];

  static EntryType getType(DiaryEntry entry) {
    if (entry is MealEntry) {
      return EntryType.meal;
    } else if (entry is SymptomEntry) {
      return EntryType.symptom;
    } else if (entry is BowelMovementEntry) {
      return EntryType.bowelMovement;
    } else {
      throw Exception("Not a valid type");
    }
  }
}

enum EntryType {
  meal,
  symptom,
  bowelMovement,
}
