part of 'diary_bloc.dart';

abstract class DiaryEvent extends Equatable {
  const DiaryEvent();

  @override
  List<Object> get props => [];
}

class GetDiaryMeals extends DiaryEvent {}

class AddMealToDiary extends DiaryEvent {
  final Meal meal;

  const AddMealToDiary(this.meal);

  @override
  List<Object> get props => [meal];
}

class UpdateMealInDiary extends DiaryEvent {
  final Meal meal;

  const UpdateMealInDiary(this.meal);

  @override
  List<Object> get props => [meal];
}

class DeleteMealFromDiary extends DiaryEvent {
  final int dateTimeMicroseconds;

  const DeleteMealFromDiary(
    this.dateTimeMicroseconds,
  );

  @override
  List<Object> get props => [dateTimeMicroseconds];
}
