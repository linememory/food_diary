import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';

class SymptomEntry extends DiaryEntry {
  final List<Symptom> symptoms;

  const SymptomEntry({
    int? id,
    required DateTime dateTime,
    required this.symptoms,
  }) : super(id: id, dateTime: dateTime);

  SymptomEntry.from(SymptomEntry diaryEntry)
      : symptoms = List.from(diaryEntry.symptoms),
        super(id: diaryEntry.id, dateTime: diaryEntry.dateTime);

  @override
  SymptomEntry copyWith({
    int? id,
    DateTime? dateTime,
    List<Symptom>? symptoms,
  }) {
    return SymptomEntry(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      symptoms: symptoms ?? List.from(this.symptoms),
    );
  }

  @override
  List<Object?> get props => super.props..add(symptoms);
}
