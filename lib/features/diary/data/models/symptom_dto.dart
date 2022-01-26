import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';

class SymptomDTO extends Equatable {
  final int? id;
  final String description;
  final int intensity;
  final int entryId;
  const SymptomDTO({
    this.id,
    required this.description,
    required this.intensity,
    required this.entryId,
  });

  SymptomDTO copyWith({
    int? id,
    String? description,
    int? intensity,
    int? entryId,
  }) {
    return SymptomDTO(
        id: id ?? this.id,
        description: description ?? this.description,
        intensity: intensity ?? this.intensity,
        entryId: entryId ?? this.entryId);
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'intensity': intensity,
      'entry_id': entryId,
    };
  }

  factory SymptomDTO.fromMap(Map<String, dynamic> map) {
    return SymptomDTO(
      id: map['id'],
      description: map['description'],
      intensity: map['intensity'],
      entryId: map['entry_id'],
    );
  }

  SymptomDTO.fromEntity({
    required this.entryId,
    required Symptom symptom,
  })  : id = null,
        description = symptom.name,
        intensity = symptom.intensity.index;

  Symptom toEntity() {
    return Symptom(name: description, intensity: Intensity.values[intensity]);
  }

  @override
  String toString() =>
      'SymptomDTO(id: $id, description: $description, intensity: $intensity)';

  @override
  List<Object?> get props => [description, intensity, entryId];
}
