import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/meal_form_food_item.dart';

part 'meal_form_event.dart';
part 'meal_form_state.dart';

class MealFormBloc extends Bloc<MealFormEvent, MealFormState> {
  final DiaryFacadeService diaryFacadeService;
  MealFormBloc(this.diaryFacadeService, int? id)
      : super(MealFormInitial(
            id: id,
            dateTime: DateTime.now(),
            foods: const [MealFormFoodItem("", Amount.small)])) {
    on<MealFormNameChanged>((event, emit) {
      List<MealFormFoodItem> foods =
          state.foods.map((item) => MealFormFoodItem.from(item)).toList();
      foods[event.id] = MealFormFoodItem(event.name, foods[event.id].amount);
      if (event.id == state.foods.length - 1 && event.name.isNotEmpty) {
        foods.add(const MealFormFoodItem("", Amount.small));
      }
      emit(MealFormChanged(dateTime: state.dateTime, foods: foods));
    });

    on<MealFormAmountChanged>((event, emit) {
      List<MealFormFoodItem> foods =
          state.foods.map((item) => MealFormFoodItem.from(item)).toList();
      foods[event.id] = MealFormFoodItem(foods[event.id].name, event.amount);
      emit(MealFormChanged(dateTime: state.dateTime, foods: foods));
    });

    on<MealFormDateTimeChanged>((event, emit) {
      emit(MealFormChanged(
          dateTime: event.dateTime, foods: List.from(state.foods)));
    });

    on<MealFormUpdateMeal>((event, emit) async {
      emit(MealFormChanged(
          dateTime: event.dateTime,
          foods: event.items..add(const MealFormFoodItem("", Amount.small))));
    });

    on<MealFormSubmit>((event, emit) async {
      Meal meal =
          Meal(dateTime: state.dateTime, foods: _foodsToAdd(state.foods));
      await diaryFacadeService.addMeal(meal);
      emit(MealFormSubmitted(
          dateTime: state.dateTime, foods: List.from(state.foods)));
    });

    on<MealFormEvent>((event, emit) {});
  }

  @override
  void onChange(Change<MealFormState> change) {
    log(change.toString());
    super.onChange(change);
  }

  List<Food> _foodsToAdd(List<MealFormFoodItem> foodsToAdd) {
    List<Food> foods = [];
    for (var foodItem in foodsToAdd) {
      if (foodItem.name.isNotEmpty) {
        foods.add(Food(name: foodItem.name, amount: foodItem.amount));
      }
    }
    return foods;
  }
}
