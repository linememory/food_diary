import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';

part 'diary_event.dart';
part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final DiaryFacadeService diaryFacadeService;

  DiaryBloc({required this.diaryFacadeService})
      : super(const DiaryLoadInProgress([])) {
    on<DiaryGetMeals>((event, emit) async {
      emit(DiaryLoadInProgress(state.meals));
      final meals = await diaryFacadeService.getAllMeals();
      meals.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      if (meals.isNotEmpty) {
        emit(DiaryLoadSuccess(meals));
      } else {
        emit(const DiaryEmpty());
      }
    });

    on<DiaryAddMeal>((event, emit) async {
      bool isAdded = await diaryFacadeService.addMeal(event.meal);
      if (isAdded) {
        List<Meal> meals = List.from(state.meals);
        int index = meals.indexWhere(
            (element) => element.dateTime.isAfter(event.meal.dateTime));
        meals.insert(index > -1 ? index : 0, event.meal);

        //meals.insert(0, event.meal);
        emit(DiaryLoadSuccess(meals));
      } else {
        var stateType = state.runtimeType;
        emit(DiaryAddFailure(state.meals, "Meal could not be added"));
        emit(stateType == DiaryEmpty
            ? const DiaryEmpty()
            : DiaryLoadSuccess(state.meals));
      }
    });

    on<DiaryUpdateMeal>((event, emit) async {
      List<Meal> meals = List.from(state.meals);
      int index =
          meals.indexWhere((meal) => meal.dateTime == event.meal.dateTime);
      if (index >= 0) {
        bool isUpdated = await diaryFacadeService.updateMeal(event.meal);
        if (isUpdated) {
          meals[index] = event.meal;
          emit(DiaryLoadSuccess(meals));
        } else {
          var stateType = state.runtimeType;
          emit(DiaryUpdateFailure(state.meals, "Meal could not be updated"));
          emit(stateType == DiaryEmpty
              ? const DiaryEmpty()
              : DiaryLoadSuccess(state.meals));
        }
      } else {
        var stateType = state.runtimeType;
        emit(DiaryUpdateFailure(meals, "No meal to update"));
        emit(stateType == DiaryEmpty
            ? const DiaryEmpty()
            : DiaryLoadSuccess(state.meals));
      }
    });

    on<DiaryDeleteMeal>((event, emit) async {
      List<Meal> meals = List.from(state.meals);
      int index = meals.indexWhere((meal) => meal.dateTime == event.dateTime);

      if (index < 0) {
        var stateType = state.runtimeType;
        emit(DiaryDeleteFailure(state.meals, "No meal to delete"));
        emit(stateType == DiaryEmpty || state.meals.isEmpty
            ? const DiaryEmpty()
            : DiaryLoadSuccess(state.meals));
      } else {
        bool isDeleted = await diaryFacadeService.deleteMeal(event.dateTime);
        if (isDeleted) {
          meals.removeAt(index);
          emit(meals.isNotEmpty ? DiaryLoadSuccess(meals) : const DiaryEmpty());
        } else {
          var stateType = state.runtimeType;
          emit(DiaryDeleteFailure(state.meals, "Meal could not be deleted"));
          emit(stateType == DiaryEmpty || state.meals.isEmpty
              ? const DiaryEmpty()
              : DiaryLoadSuccess(state.meals));
        }
      }
    });
    add(DiaryGetMeals());
  }

  @override
  void onChange(Change<DiaryState> change) {
    //log(change.currentState)
    log(change.toString());
    super.onChange(change);
  }
}
