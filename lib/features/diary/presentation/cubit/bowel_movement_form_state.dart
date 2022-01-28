part of 'bowel_movement_form_cubit.dart';

abstract class BowelMovementFormState extends Equatable {
  const BowelMovementFormState(this.dateTime, this.bowelMovement);

  final DateTime dateTime;
  final List<BowelMovement> bowelMovement;

  @override
  List<Object?> get props => [dateTime, bowelMovement];
}

class BowelMovementFormInitial extends BowelMovementFormState {
  const BowelMovementFormInitial(
      DateTime dateTime, List<BowelMovement> bowelMovement)
      : super(dateTime, bowelMovement);
}

class BowelMovementFormChanged extends BowelMovementFormState {
  const BowelMovementFormChanged(
      DateTime dateTime, List<BowelMovement> bowelMovement)
      : super(dateTime, bowelMovement);
}

class BowelMovementFormSubmitted extends BowelMovementFormState {
  const BowelMovementFormSubmitted(
      DateTime dateTime, List<BowelMovement> bowelMovement)
      : super(dateTime, bowelMovement);
}
