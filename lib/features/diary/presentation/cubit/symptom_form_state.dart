part of 'symptom_form_cubit.dart';

abstract class SymptomFormState extends Equatable {
  const SymptomFormState(this.data);

  final Data data;

  @override
  List<Object?> get props => [data];
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
