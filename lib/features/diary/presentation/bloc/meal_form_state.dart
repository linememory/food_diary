part of 'meal_form_bloc.dart';

abstract class MealFormState extends Equatable {
  const MealFormState(this.dateTime, this.foods);
  
  final DateTime dateTime;
  final List<MealFormFoodItem> foods;

  @override
  List<Object> get props => [dateTime, foods];
}

class MealFormInitial extends MealFormState {
  const MealFormInitial({
    required DateTime dateTime,
    required List<MealFormFoodItem> foods,
  }) : super(dateTime, foods);
}

class MealFormChanged extends MealFormState {
  const MealFormChanged({
    required DateTime dateTime,
    required List<MealFormFoodItem> foods,
  }) : super(dateTime, foods);
}

class MealFormSubmitted extends MealFormState {
  const MealFormSubmitted({
    required DateTime dateTime,
    required List<MealFormFoodItem> foods,
  }) : super(dateTime, foods);
}
