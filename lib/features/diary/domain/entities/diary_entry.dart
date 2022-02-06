import 'package:equatable/equatable.dart';

abstract class DiaryEntry extends Equatable {
  final int? id;
  final DateTime dateTime;

  const DiaryEntry({
    this.id,
    required this.dateTime,
  });

  DiaryEntry.from(DiaryEntry entry)
      : id = entry.id,
        dateTime = entry.dateTime;

  DiaryEntry copyWith({
    int? id,
    DateTime? dateTime,
  });

  @override
  List<Object?> get props => [id, dateTime];
}
