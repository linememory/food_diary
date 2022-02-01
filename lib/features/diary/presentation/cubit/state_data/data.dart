import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';

abstract class Data {
  final int? id;
  final DateTime dateTime;
  final List<Field> fields;
  Data({
    this.id,
    required this.dateTime,
    required this.fields,
  });

  Data.from(Data data)
      : id = data.id,
        dateTime = data.dateTime,
        fields = data.fields;

  Data fromEntity(DiaryEntry entry);

  Data copyWith({
    final int? id,
    final DateTime? dateTime,
    final List<Field>? fields,
  });

  DiaryEntry toEntity();

  void addEmpty();
}

abstract class Field {}
