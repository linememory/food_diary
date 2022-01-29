part of 'bowel_movement_form_cubit.dart';

abstract class BowelMovementFormState extends Equatable {
  const BowelMovementFormState(this.bowelMovementEntry);

  final BowelMovementEntry bowelMovementEntry;

  @override
  List<Object?> get props => [bowelMovementEntry];
}

class BowelMovementFormInitial extends BowelMovementFormState {
  const BowelMovementFormInitial(BowelMovementEntry bowelMovementEntry)
      : super(bowelMovementEntry);
}

class BowelMovementFormChanged extends BowelMovementFormState {
  const BowelMovementFormChanged(BowelMovementEntry bowelMovementEntry)
      : super(bowelMovementEntry);
}

class BowelMovementFormSubmitted extends BowelMovementFormState {
  const BowelMovementFormSubmitted(BowelMovementEntry bowelMovementEntry)
      : super(bowelMovementEntry);
}
