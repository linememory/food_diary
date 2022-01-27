part of 'meal_form_bloc.dart';

abstract class MealFormState extends Equatable {
  const MealFormState({this.id, required this.dateTime, required this.foods});
  final int? id;
  final DateTime dateTime;
  final List<Food> foods;

  @override
  List<Object> get props => [dateTime, foods];
}

class MealFormInitial extends MealFormState {
  const MealFormInitial({
    int? id,
    required DateTime dateTime,
    required List<Food> foods,
  }) : super(id: id, dateTime: dateTime, foods: foods);
}

class MealFormChanged extends MealFormState {
  const MealFormChanged({
    int? id,
    required DateTime dateTime,
    required List<Food> foods,
  }) : super(id: id, dateTime: dateTime, foods: foods);
}

class MealFormSubmitted extends MealFormState {
  const MealFormSubmitted({
    int? id,
    required DateTime dateTime,
    required List<Food> foods,
  }) : super(id: id, dateTime: dateTime, foods: foods);
}

class MealFormSubmitFailed extends MealFormState {
  final String message;
  const MealFormSubmitFailed({
    int? id,
    required DateTime dateTime,
    required List<Food> foods,
    required this.message,
  }) : super(id: id, dateTime: dateTime, foods: foods);
}
