import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';
import 'package:food_diary/features/diary/presentation/cubit/entry_form_cubit.dart';

part 'symptom_form_state.dart';

class SymptomFormCubit extends Cubit<SymptomFormState> {
  final EntryFormCubit _entryFormCubit;
  SymptomFormCubit(SymptomEntry? symptomEntry, this._entryFormCubit)
      : super(
          SymptomFormInitial((symptomEntry ??
              SymptomEntry(dateTime: DateTime.now(), symptoms: const []))
            ..symptoms.add(const Symptom(name: "", intensity: Intensity.low))),
        );

  void dateTimeChanged(DateTime newDateTime) {
    emit(
        SymptomFormChanged(state.symptomEntry.copyWith(dateTime: newDateTime)));
    notifyEntryFormCubit(state.symptomEntry);
  }

  void nameChanged(int id, String name) {
    List<Symptom> symptoms = List.from(state.symptomEntry.symptoms);
    symptoms[id] = symptoms[id].copyWith(name: name);
    if (id == state.symptomEntry.symptoms.length - 1) {
      symptoms.add(const Symptom(name: "", intensity: Intensity.low));
    }
    emit(SymptomFormChanged(state.symptomEntry.copyWith(symptoms: symptoms)));
    notifyEntryFormCubit(state.symptomEntry);
  }

  void intensityChanged(int id, Intensity intensity) {
    List<Symptom> symptoms = List.from(state.symptomEntry.symptoms);
    symptoms[id] = symptoms[id].copyWith(intensity: intensity);
    emit(SymptomFormChanged(state.symptomEntry.copyWith(symptoms: symptoms)));
    notifyEntryFormCubit(state.symptomEntry);
  }

  void submit() {
    emit(SymptomFormSubmitted(state.symptomEntry));
  }

  void notifyEntryFormCubit(SymptomEntry entry) {
    _entryFormCubit.formValid(entry.copyWith()..symptoms.removeLast());
  }
}
