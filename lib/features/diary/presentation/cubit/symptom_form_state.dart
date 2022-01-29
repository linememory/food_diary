part of 'symptom_form_cubit.dart';

abstract class SymptomFormState extends Equatable {
  const SymptomFormState(this.symptomEntry);

  final SymptomEntry symptomEntry;

  @override
  List<Object?> get props => [symptomEntry];
}

class SymptomFormInitial extends SymptomFormState {
  const SymptomFormInitial(SymptomEntry symptomEntry) : super(symptomEntry);
}

class SymptomFormChanged extends SymptomFormState {
  const SymptomFormChanged(SymptomEntry symptomEntry) : super(symptomEntry);
}

class SymptomFormSubmitted extends SymptomFormState {
  const SymptomFormSubmitted(SymptomEntry symptomEntry) : super(symptomEntry);
}
