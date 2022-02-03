part of 'bowel_movement_form_cubit.dart';

abstract class BowelMovementFormState extends Equatable {
  final Data data;
  const BowelMovementFormState(this.data);

  @override
  List<Object?> get props => [data];
}

class BowelMovementFormInitial extends BowelMovementFormState {
  const BowelMovementFormInitial(Data data) : super(data);
}

class BowelMovementFormChanged extends BowelMovementFormState {
  const BowelMovementFormChanged(Data data) : super(data);
}

class BowelMovementFormSubmitted extends BowelMovementFormState {
  const BowelMovementFormSubmitted(Data data) : super(data);
}
