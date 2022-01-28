part of 'symptom_form_cubit.dart';

abstract class SymptomFormState extends Equatable {
  const SymptomFormState(this.dateTime, this.symptoms);

  final DateTime dateTime;
  final List<Symptom> symptoms;

  @override
  List<Object?> get props => [dateTime, symptoms];
}

class SymptomFormInitial extends SymptomFormState {
  const SymptomFormInitial(DateTime dateTime, List<Symptom> symptoms)
      : super(dateTime, symptoms);
}

class SymptomFormChanged extends SymptomFormState {
  const SymptomFormChanged(DateTime dateTime, List<Symptom> symptoms)
      : super(dateTime, symptoms);
}

class SymptomFormSubmitted extends SymptomFormState {
  const SymptomFormSubmitted(DateTime dateTime, List<Symptom> symptoms)
      : super(dateTime, symptoms);
}
