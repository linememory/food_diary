import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/entities/event.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';

class EventDTO extends Equatable {
  final int? id;
  final DateTime dateTime;
  final EventType type;
  const EventDTO({
    this.id,
    required this.dateTime,
    required this.type,
  });

  EventDTO copyWith({
    int? id,
    DateTime? dateTime,
    EventType? type,
  }) {
    return EventDTO(
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

  factory EventDTO.fromMap(Map<String, dynamic> map) {
    return EventDTO(
      id: map['id']?.toInt(),
      dateTime: DateTime.fromMicrosecondsSinceEpoch(map['date_time']),
      type: EventType.values[map['type']],
    );
  }

  Event toEventEntity<T>(T event) {
    return Event(dateTime: dateTime, event: event);
  }

  EventDTO.fromEventEntity(Event event)
      : id = event.id,
        dateTime = event.dateTime,
        type = getType(event);

  Event<T> toEvent<T>(T event) {
    return Event<T>(id: id, dateTime: dateTime, event: event);
  }

  @override
  String toString() => 'EventDTO(id: $id, dateTime: $dateTime)';

  @override
  List<Object?> get props => [id, dateTime];

  static EventType getType(Event event) {
    switch (event.event.runtimeType) {
      case Symptom:
        return EventType.symptoms;
      case BowelMovement:
        return EventType.bowelMovement;

      default:
        throw Exception("Not a valid type");
    }
  }
}

enum EventType {
  symptoms,
  bowelMovement,
}
