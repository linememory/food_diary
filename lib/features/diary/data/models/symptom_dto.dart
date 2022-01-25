import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';

class SymptomDTO extends Equatable {
  final int? id;
  final String description;
  final int intensity;
  final int eventId;
  const SymptomDTO({
    this.id,
    required this.description,
    required this.intensity,
    required this.eventId,
  });

  SymptomDTO copyWith({
    int? id,
    String? description,
    int? intensity,
    int? eventId,
  }) {
    return SymptomDTO(
        id: id ?? this.id,
        description: description ?? this.description,
        intensity: intensity ?? this.intensity,
        eventId: eventId ?? this.eventId);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'intensity': intensity,
      'event_id': eventId,
    };
  }

  factory SymptomDTO.fromMap(Map<String, dynamic> map) {
    return SymptomDTO(
      id: map['id']?.toInt(),
      description: map['description'],
      intensity: map['intensity'],
      eventId: map['event_id'],
    );
  }

  SymptomDTO.fromSymptomEntity(
      {required this.eventId, required Symptom symptom})
      : id = null,
        description = symptom.name,
        intensity = symptom.intensity.index;

  Symptom toSymptomEntity() {
    return Symptom(name: description, intensity: Intensity.values[intensity]);
  }

  @override
  String toString() =>
      'SymptomDTO(id: $id, description: $description, intensity: $intensity)';

  @override
  List<Object?> get props => [id, description, intensity];
}
