import 'package:equatable/equatable.dart';

class Event<T> extends Equatable {
  final int? id;
  final DateTime dateTime;
  final T event;

  const Event({
    this.id,
    required this.dateTime,
    required this.event,
  });

  Event.from(Event event)
      : id = event.id,
        dateTime = event.dateTime,
        event = event.event;

  Event<T> copyWith({
    int? id,
    DateTime? dateTime,
    T? event,
  }) {
    return Event<T>(
        id: id ?? this.id,
        dateTime: dateTime ?? this.dateTime,
        event: event ?? this.event);
  }

  @override
  List<Object?> get props => [id, dateTime, event];
}
