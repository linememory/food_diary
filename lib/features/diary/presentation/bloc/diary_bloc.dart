import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/meal_item.dart';

part 'diary_event.dart';
part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final DiaryFacadeService diaryFacadeService;

  DiaryBloc({required this.diaryFacadeService})
      : super(const DiaryLoadInProgress([])) {
    on<DiaryGetMeals>((event, emit) async {
      emit(DiaryLoadInProgress(state.meals));
      List<MealItem> meals = (await diaryFacadeService.getAllMeals())
          .map((e) => MealItem.fromMealEntity(e))
          .toList();
      meals.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      if (meals.isNotEmpty) {
        emit(DiaryLoadSuccess(meals));
      } else {
        emit(const DiaryEmpty());
      }
    });

    on<DiaryAddMeal>((event, emit) async {
      bool isAdded =
          await diaryFacadeService.addMeal(event.meal.toMealEntity());
      if (isAdded) {
        List<MealItem> meals = List.from(state.meals);
        int index = meals.indexWhere(
            (element) => element.dateTime.isAfter(event.meal.dateTime));
        meals.insert(index > -1 ? index : 0, event.meal);
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
      List<MealItem> meals = state.meals.map((e) => MealItem.from(e)).toList();
      int index = meals.indexWhere((meal) => meal.id == event.meal.id);
      if (index >= 0) {
        bool isUpdated =
            await diaryFacadeService.updateMeal(event.meal.toMealEntity());
        if (isUpdated) {
          meals[index] = event.meal;
          emit(DiaryLoadSuccess(List.from(meals)));
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
      List<MealItem> meals = List.from(state.meals);
      int index = meals.indexWhere((meal) => meal.id == event.id);

      if (index < 0) {
        var stateType = state.runtimeType;
        emit(DiaryDeleteFailure(state.meals, "No meal to delete"));
        emit(stateType == DiaryEmpty || state.meals.isEmpty
            ? const DiaryEmpty()
            : DiaryLoadSuccess(state.meals));
      } else {
        bool isDeleted = await diaryFacadeService.deleteMeal(event.id);
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
    log(change.toString());
    super.onChange(change);
  }
}
