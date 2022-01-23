import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/food_item.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/meal_item.dart';

part 'meal_form_event.dart';
part 'meal_form_state.dart';

class MealFormBloc extends Bloc<MealFormEvent, MealFormState> {
  final DiaryFacadeService diaryFacadeService;
  final MealItem? mealItem;
  //final int? mealId;
  MealFormBloc(this.diaryFacadeService, this.mealItem)
      : super(MealFormInitial(
            dateTime: mealItem?.dateTime ?? DateTime.now(),
            foods: List.generate(
                mealItem?.foods.length ?? 0, (index) => mealItem!.foods[index])
              ..add(const FoodItem("", Amount.small)))) {
    on<MealFormNameChanged>((event, emit) {
      List<FoodItem> foods =
          state.foods.map((item) => FoodItem.from(item)).toList();
      foods[event.id] = FoodItem(event.name, foods[event.id].amount);
      if (event.id == state.foods.length - 1 && event.name.isNotEmpty) {
        foods.add(const FoodItem("", Amount.small));
      }
      emit(MealFormChanged(dateTime: state.dateTime, foods: foods));
    });

    on<MealFormAmountChanged>((event, emit) {
      List<FoodItem> foods =
          state.foods.map((item) => FoodItem.from(item)).toList();
      foods[event.id] = FoodItem(foods[event.id].name, event.amount);
      emit(MealFormChanged(dateTime: state.dateTime, foods: foods));
    });

    on<MealFormDateTimeChanged>((event, emit) {
      emit(MealFormChanged(
          dateTime: event.dateTime, foods: List.from(state.foods)));
    });

    // on<MealFormUpdateMeal>((event, emit) async {
    //   emit(MealFormChanged(
    //       dateTime: event.dateTime,
    //       foods: event.items..add(const FoodItem("", Amount.small))));
    // });

    on<MealFormSubmit>((event, emit) async {
      if (isValid(state.foods)) {
        Meal meal = Meal(
            id: mealItem?.id,
            dateTime: state.dateTime,
            foods: _foodsToAdd(state.foods));
        await diaryFacadeService.addMeal(meal);
        emit(MealFormSubmitted(
            dateTime: state.dateTime, foods: List.from(state.foods)));
      } else {
        emit(MealFormSubmitFailed(
            dateTime: state.dateTime,
            foods: state.foods,
            message: "Form not valid"));

        //emit(MealFormInitial(dateTime: state.dateTime, foods: state.foods));
      }
    });

    on<MealFormEvent>((event, emit) {});
  }

  @override
  void onChange(Change<MealFormState> change) {
    log(change.toString());
    super.onChange(change);
  }

  List<Food> _foodsToAdd(List<FoodItem> foodsToAdd) {
    List<Food> foods = [];
    for (var foodItem in foodsToAdd) {
      if (foodItem.name.isNotEmpty) {
        foods.add(Food(name: foodItem.name, amount: foodItem.amount));
      }
    }
    return foods;
  }

  bool isValid(List<FoodItem> foods) {
    for (var food in foods) {
      if (food.name.isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}
