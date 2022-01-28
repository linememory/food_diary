import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';

part 'symptom_form_state.dart';

class SymptomFormCubit extends Cubit<SymptomFormState> {
  SymptomFormCubit()
      : super(
          SymptomFormInitial(
            DateTime.now(),
            const [Symptom(name: "", intensity: Intensity.low)],
          ),
        );

  void nameChanged(int id, String name) {
    emit(SymptomFormChanged(state.dateTime, state.symptoms));
  }

  void intensityChanged(int id, int intensity) {
    emit(SymptomFormChanged(state.dateTime, state.symptoms));
  }

  void submit() {
    emit(SymptomFormSubmitted(state.dateTime, state.symptoms));
  }
}
