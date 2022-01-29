part of 'meal_form_cubit.dart';

abstract class MealFormState extends Equatable {
  const MealFormState(this.mealEntry);
  final MealEntry mealEntry;

  @override
  List<Object?> get props => [mealEntry];
}

class MealFormInitial extends MealFormState {
  const MealFormInitial(MealEntry mealEntry) : super(mealEntry);
}

class MealFormChanged extends MealFormState {
  const MealFormChanged(MealEntry mealEntry) : super(mealEntry);
}

class MealFormSubmitted extends MealFormState {
  const MealFormSubmitted(MealEntry mealEntry) : super(mealEntry);
}
