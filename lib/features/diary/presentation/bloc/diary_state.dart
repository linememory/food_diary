part of 'diary_bloc.dart';

abstract class DiaryState extends Equatable {
  final List<Meal> meals;
  const DiaryState(this.meals);

  @override
  List<Object> get props => [meals];
}

class Loading extends DiaryState {
  const Loading(List<Meal> meals) : super(meals);
}

class Loaded extends DiaryState {
  const Loaded(List<Meal> meals) : super(meals);
}

class Empty extends DiaryState {
  final String message = "No meals tracked";

  const Empty(List<Meal> meals) : super(meals);

  @override
  List<Object> get props => [meals, message];
}

class Failure extends DiaryState {
  final String reason;

  const Failure(List<Meal> meals, this.reason) : super(meals);

  @override
  List<Object> get props => [meals, reason];
}

class MealNotAdded extends Failure {
  const MealNotAdded(List<Meal> meals, String reason) : super(meals, reason);
}

class MealNotUpdated extends Failure {
  const MealNotUpdated(List<Meal> meals, String reason) : super(meals, reason);
}

class MealNotDeleted extends Failure {
  const MealNotDeleted(List<Meal> meals, String reason) : super(meals, reason);
}
