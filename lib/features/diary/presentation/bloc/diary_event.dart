part of 'diary_bloc.dart';

abstract class DiaryEvent extends Equatable {
  const DiaryEvent();

  @override
  List<Object> get props => [];
}

class DiaryGetMeals extends DiaryEvent {}

class DiaryAddMeal extends DiaryEvent {
  final Meal meal;

  const DiaryAddMeal(this.meal);

  @override
  List<Object> get props => [meal];
}

class DiaryUpdateMeal extends DiaryEvent {
  final Meal meal;

  const DiaryUpdateMeal(this.meal);

  @override
  List<Object> get props => [meal];
}

class DiaryDeleteMeal extends DiaryEvent {
  final int id;

  const DiaryDeleteMeal(
    this.id,
  );

  @override
  List<Object> get props => [id];
}
