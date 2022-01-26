import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/entry_item.dart';

class SymptomsItem extends EntryItem {
  final List<SymptomItem> symptoms;

  const SymptomsItem(
      {int? id, required DateTime dateTime, required this.symptoms})
      : super(id: id, dateTime: dateTime);

  SymptomsItem.from(SymptomsItem item)
      : symptoms = item.symptoms,
        super(id: item.id, dateTime: item.dateTime);

  SymptomsItem fromEntity(SymptomEntry symptomEntry) {
    return SymptomsItem(
        id: symptomEntry.id,
        dateTime: symptomEntry.dateTime,
        symptoms: symptomEntry.symptoms
            .map((e) => SymptomItem.fromEntity(e))
            .toList());
  }

  SymptomsItem.fromEntity(SymptomEntry symptomEntry)
      : symptoms = symptomEntry.symptoms
            .map((e) => SymptomItem.fromEntity(e))
            .toList(),
        super(id: symptomEntry.id, dateTime: symptomEntry.dateTime);

  @override
  SymptomEntry toEntity() {
    return SymptomEntry(
        id: id,
        dateTime: dateTime,
        symptoms: symptoms.map((e) => e.toEntity()).toList());
  }

  @override
  List<Object?> get props => super.props..add(symptoms);
}

class SymptomItem extends Equatable {
  final String name;
  final Intensity intensity;

  const SymptomItem({required this.name, required this.intensity});
  SymptomItem.from(SymptomItem item)
      : name = item.name,
        intensity = item.intensity;

  SymptomItem.fromEntity(Symptom food)
      : name = food.name,
        intensity = food.intensity;

  Symptom toEntity() {
    return Symptom(name: name, intensity: intensity);
  }

  @override
  List<Object?> get props => [name, intensity];
}
