part of 'meal_form_cubit.dart';

abstract class MealFormState {
  const MealFormState(this.data);

  final Data data;
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
