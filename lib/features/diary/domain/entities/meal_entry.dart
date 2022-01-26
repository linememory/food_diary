import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';

class MealEntry extends DiaryEntry {
  final List<Food> foods;

  const MealEntry({
    int? id,
    required DateTime dateTime,
    required this.foods,
  }) : super(id: id, dateTime: dateTime);

  MealEntry.from(MealEntry diaryEntry)
      : foods = diaryEntry.foods,
        super(id: diaryEntry.id, dateTime: diaryEntry.dateTime);

  @override
  MealEntry copyWith({
    int? id,
    DateTime? dateTime,
    List<Food>? foods,
  }) {
    return MealEntry(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      foods: foods ?? this.foods,
    );
  }

  @override
  List<Object?> get props => super.props..add(foods);
}
