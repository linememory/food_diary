part of 'meal_form_bloc.dart';

abstract class MealFormEvent extends Equatable {
  const MealFormEvent();

  @override
  List<Object> get props => [];
}

class MealFormDateTimeChanged extends MealFormEvent {
  final DateTime dateTime;

  const MealFormDateTimeChanged(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class MealFormNameChanged extends MealFormEvent {
  final String name;
  final int id;

  const MealFormNameChanged(this.id, this.name);

  @override
  List<Object> get props => [id, name];
}

class MealFormAmountChanged extends MealFormEvent {
  final Amount amount;
  final int id;

  const MealFormAmountChanged(this.id, this.amount);

  @override
  List<Object> get props => [id, amount];
}

class MealFormRemoveFood extends MealFormEvent {
  final int id;

  const MealFormRemoveFood(this.id);

  @override
  List<Object> get props => [id];
}

class MealFormUpdateMeal extends MealFormEvent {
  final DateTime dateTime;
  final List<MealFormFoodItem> items;

  const MealFormUpdateMeal(this.dateTime, this.items);

  @override
  List<Object> get props => [items];
}

class MealFormSubmit extends MealFormEvent {}
