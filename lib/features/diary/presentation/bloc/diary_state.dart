part of 'diary_bloc.dart';

abstract class DiaryState extends Equatable {
  final List<Meal> meals;
  const DiaryState(this.meals);

  @override
  List<Object> get props => [meals];

  @override
  String toString() => '$runtimeType (meals: ${meals.length})';
}

class DiaryLoadInProgress extends DiaryState {
  const DiaryLoadInProgress(List<Meal> meals) : super(meals);
}

class DiaryLoadSuccess extends DiaryState {
  const DiaryLoadSuccess(List<Meal> meals) : super(meals);
}

class DiaryEmpty extends DiaryState {
  final String message = "No meals tracked";

  const DiaryEmpty() : super(const []);

  @override
  List<Object> get props => [meals, message];
}

class DiaryFailure extends DiaryState {
  final String reason;

  const DiaryFailure(List<Meal> meals, this.reason) : super(meals);

  @override
  List<Object> get props => [meals, reason];
}

class DiaryAddFailure extends DiaryFailure {
  const DiaryAddFailure(List<Meal> meals, String reason) : super(meals, reason);
}

class DiaryUpdateFailure extends DiaryFailure {
  const DiaryUpdateFailure(List<Meal> meals, String reason)
      : super(meals, reason);
}

class DiaryDeleteFailure extends DiaryFailure {
  const DiaryDeleteFailure(List<Meal> meals, String reason)
      : super(meals, reason);
}
