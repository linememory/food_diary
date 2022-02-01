part of 'symptom_form_cubit.dart';

abstract class SymptomFormState {
  const SymptomFormState(this.data);

  final Data data;
}

class SymptomFormInitial extends SymptomFormState {
  const SymptomFormInitial(Data data) : super(data);
}

class SymptomFormChanged extends SymptomFormState {
  const SymptomFormChanged(Data data) : super(data);
}

class SymptomFormSubmitted extends SymptomFormState {
  const SymptomFormSubmitted(Data data) : super(data);
}
