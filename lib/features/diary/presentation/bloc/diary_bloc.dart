import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/dev/add_test_content.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/usecases/add_meal.dart';
import 'package:food_diary/features/diary/domain/usecases/delete_meal.dart';
import 'package:food_diary/features/diary/domain/usecases/get_all_meals.dart';
import 'package:food_diary/features/diary/domain/usecases/update_meal.dart';
import 'package:food_diary/features/diary/domain/usecases/usecase.dart';
import 'package:food_diary/injection_container.dart';

part 'diary_event.dart';
part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final GetAllMeals getAllMeals;
  final AddMeal addMeal;
  final UpdateMeal updateMeal;
  final DeleteMeal deleteMeal;

  DiaryBloc(
      {required this.getAllMeals,
      required this.addMeal,
      required this.updateMeal,
      required this.deleteMeal})
      : super(const DiaryLoadInProgress([])) {
    on<DiaryGetMeals>((event, emit) async {
      emit(DiaryLoadInProgress(state.meals));
      final meals = await getAllMeals(Param.noParam());
      meals.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      if (meals.isNotEmpty) {
        emit(DiaryLoadSuccess(meals));
      } else {
        emit(const DiaryEmpty());
      }
    });

    on<DiaryAddMeal>((event, emit) async {
      bool isAdded = await addMeal(Param(event.meal));
      if (isAdded) {
        List<Meal> meals = List.from(state.meals);
        meals.insert(0, event.meal);
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
        bool isUpdated = await updateMeal(Param(event.meal));
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
        bool isDeleted = await deleteMeal(Param(event.dateTime));
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
