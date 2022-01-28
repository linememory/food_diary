part of 'meal_form_cubit.dart';

abstract class MealFormState extends Equatable {
  const MealFormState(this.dateTime, this.food);

  final DateTime dateTime;
  final List<Food> food;

  @override
  List<Object?> get props => [dateTime, food];
}

class MealFormInitial extends MealFormState {
  const MealFormInitial(DateTime dateTime, List<Food> food)
      : super(dateTime, food);
}

class MealFormChanged extends MealFormState {
  const MealFormChanged(DateTime dateTime, List<Food> food)
      : super(dateTime, food);
}

class MealFormSubmitted extends MealFormState {
  const MealFormSubmitted(DateTime dateTime, List<Food> food)
      : super(dateTime, food);
}
