import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';

abstract class EntryItem extends Equatable {
  final int? id;
  final DateTime dateTime;

  const EntryItem({this.id, required this.dateTime});
  EntryItem.from(EntryItem item)
      : id = item.id,
        dateTime = item.dateTime;

  DiaryEntry toEntity();

  @override
  List<Object?> get props => [id, dateTime];
}
