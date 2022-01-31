import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
import 'package:food_diary/features/diary/presentation/cubit/entry_form_cubit.dart';

part 'meal_form_state.dart';

class MealFormCubit extends Cubit<MealFormState> {
  final EntryFormCubit _entryFormCubit;
  MealFormCubit(MealEntry? mealEntry, this._entryFormCubit)
      : super(MealFormInitial(
            (mealEntry ??
                MealEntry(
                  dateTime: DateTime.now(),
                  foods: const [],
                ))
              ..foods.add(const Food(name: "", amount: Amount.small)),
            (mealEntry ??
                    MealEntry(
                      dateTime: DateTime.now(),
                      foods: const [],
                    ))
                .foods
                .map((e) => TextEditingController(text: e.name))
                .toList()
              ..add(TextEditingController())));

  void dateTimeChanged(DateTime newDateTime) {
    emit(MealFormChanged(
        state.mealEntry.copyWith(dateTime: newDateTime), state.controllers));
    notifyEntryFormCubit(state.mealEntry);
  }

  void nameChanged(int id, String name) {
    List<Food> foods = List.from(state.mealEntry.foods);
    foods[id] = foods[id].copyWith(name: name);
    if (id == state.mealEntry.foods.length - 1) {
      foods.add(const Food(name: "", amount: Amount.small));
    }
    emit(MealFormChanged(
        state.mealEntry.copyWith(foods: foods), state.controllers));
    notifyEntryFormCubit(state.mealEntry);
  }

  void amountChanged(int id, Amount amount) {
    List<Food> foods = List.from(state.mealEntry.foods);
    foods[id] = foods[id].copyWith(amount: amount);
    emit(MealFormChanged(
        state.mealEntry.copyWith(foods: foods), state.controllers));
    notifyEntryFormCubit(state.mealEntry);
  }

  void submit() {
    emit(MealFormSubmitted(state.mealEntry, state.controllers));
  }

  void notifyEntryFormCubit(MealEntry entry) {
    _entryFormCubit.formValid(entry.copyWith()..foods.removeLast());
  }
}

class Data {
  DateTime dateTime;
  List<TextEditingController> controller;
  List<int> dropdownValue;
  Data({
    required this.dateTime,
    required this.controller,
    required this.dropdownValue,
  });
}
