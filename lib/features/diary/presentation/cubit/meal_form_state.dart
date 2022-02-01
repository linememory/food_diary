part of 'meal_form_cubit.dart';

abstract class MealFormState {
  final Data data;
  const MealFormState(this.data);
}

class MealFormInitial extends MealFormState {
  const MealFormInitial(Data data) : super(data);
}

class MealFormChanged extends MealFormState {
  const MealFormChanged(Data data) : super(data);
}

class MealFormSubmitted extends MealFormState {
  const MealFormSubmitted(Data data) : super(data);
}
