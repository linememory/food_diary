part of 'meal_form_cubit.dart';

abstract class MealFormState extends Equatable {
  const MealFormState(this.mealEntry, this.controllers);
  final MealEntry mealEntry;
  final List<TextEditingController> controllers;

  @override
  List<Object?> get props => [mealEntry];
}

class MealFormInitial extends MealFormState {
  const MealFormInitial(
      MealEntry mealEntry, List<TextEditingController> controllers)
      : super(mealEntry, controllers);
}

class MealFormChanged extends MealFormState {
  const MealFormChanged(
      MealEntry mealEntry, List<TextEditingController> controllers)
      : super(mealEntry, controllers);
}

class MealFormSubmitted extends MealFormState {
  const MealFormSubmitted(
      MealEntry mealEntry, List<TextEditingController> controllers)
      : super(mealEntry, controllers);
}
