part of 'diary_bloc.dart';

abstract class DiaryState extends Equatable {
  final List<MealItem> meals;
  const DiaryState(this.meals);

  @override
  List<Object> get props => [meals];

  @override
  String toString() => '$runtimeType (meals: ${meals.length})';
}

class DiaryLoadInProgress extends DiaryState {
  const DiaryLoadInProgress(List<MealItem> meals) : super(meals);
}

class DiaryLoadSuccess extends DiaryState {
  const DiaryLoadSuccess(List<MealItem> meals) : super(meals);
}

class DiaryEmpty extends DiaryState {
  final String message = "No meals tracked";

  const DiaryEmpty() : super(const []);

  @override
  List<Object> get props => [meals, message];
}

class DiaryFailure extends DiaryState {
  final String reason;

  const DiaryFailure(List<MealItem> meals, this.reason) : super(meals);

  @override
  List<Object> get props => [meals, reason];
}

class DiaryAddFailure extends DiaryFailure {
  const DiaryAddFailure(List<MealItem> meals, String reason)
      : super(meals, reason);
}

class DiaryUpdateFailure extends DiaryFailure {
  const DiaryUpdateFailure(List<MealItem> meals, String reason)
      : super(meals, reason);
}

class DiaryDeleteFailure extends DiaryFailure {
  const DiaryDeleteFailure(List<MealItem> meals, String reason)
      : super(meals, reason);
}
