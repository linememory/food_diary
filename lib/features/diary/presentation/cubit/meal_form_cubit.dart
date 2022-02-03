import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
import 'package:food_diary/features/diary/presentation/cubit/entry_form_cubit.dart';

part 'meal_form_state.dart';

class MealFormCubit extends Cubit<MealFormState> {
  final EntryFormCubit _entryFormCubit;
  MealFormCubit(MealEntry? mealEntry, this._entryFormCubit)
      : super(
          MealFormInitial(
            Data.fromEntity(
              mealEntry ??
                  MealEntry(
                    dateTime: DateTime.now(),
                    foods: const [],
                  ),
            )..addEmpty(),
          ),
        );

  void dateTimeChanged(DateTime newDateTime) {
    emit(MealFormChanged(state.data.copyWith(dateTime: newDateTime)));
    notifyEntryFormCubit(state.data);
  }

  void nameChanged(int id, String name) {
    Data newData = Data.from(state.data);
    if (id == newData.fields.length - 1) {
      newData.addEmpty();
    }
    emit(MealFormChanged(newData));
    notifyEntryFormCubit(newData);
  }

  void amountChanged(int id, Amount amount) {
    Data newData = Data.from(state.data);
    newData.fields[id] =
        Field(amount: amount, controller: newData.fields[id].controller);

    emit(MealFormChanged(newData));
    notifyEntryFormCubit(newData);
  }

  void submit() {
    emit(MealFormSubmitted(state.data));
  }

  void notifyEntryFormCubit(Data newData) {
    MealEntry entry = newData.toEntity();
    _entryFormCubit.formValid(entry);
  }

  @override
  void onChange(Change<MealFormState> change) {
    log(change.toString());
    super.onChange(change);
  }
}

class Data {
  final int? id;
  final DateTime dateTime;
  final List<Field> fields;
  Data({
    this.id,
    required this.dateTime,
    required this.fields,
  });

  Data.from(Data data)
      : id = data.id,
        dateTime = data.dateTime,
        fields = data.fields.map((e) => Field.from(e)).toList();

  Data.fromEntity(MealEntry meal)
      : id = meal.id,
        dateTime = meal.dateTime,
        fields = meal.foods
            .map((e) => Field(
                controller: TextEditingController(text: e.name),
                amount: e.amount))
            .toList();

  Data copyWith({
    final int? id,
    final DateTime? dateTime,
    final List<Field>? fields,
  }) {
    return Data(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      fields: fields ?? this.fields.map((e) => Field.from(e)).toList(),
    );
  }

  MealEntry toEntity() {
    List<Food> foods = [];
    for (var field in fields) {
      if (field.controller.text.isNotEmpty) {
        foods.add(Food(name: field.controller.text, amount: field.amount));
      }
    }

    return MealEntry(id: id, dateTime: dateTime, foods: foods);
  }

  void addEmpty() {
    fields
        .add(Field(controller: TextEditingController(), amount: Amount.small));
  }

  removeEmptyFields() {
    fields.removeWhere((element) => element.controller.text.isEmpty);
    addEmpty();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Data &&
        other.id == id &&
        other.dateTime == dateTime &&
        listEquals(other.fields, fields);
  }

  @override
  int get hashCode => id.hashCode ^ dateTime.hashCode ^ fields.hashCode;

  @override
  String toString() => 'Data(id: $id, dateTime: $dateTime, fields: $fields)';
}

class Field {
  final TextEditingController controller;
  final Amount amount;
  Field({
    required this.controller,
    required this.amount,
  });

  Field.from(Field field)
      : controller = field.controller,
        amount = field.amount;

  Field copyWith({
    TextEditingController? controller,
    Amount? amount,
  }) {
    return Field(
      controller: controller ?? this.controller,
      amount: amount ?? this.amount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => controller.text.hashCode ^ amount.index.hashCode;

  @override
  String toString() => 'Field(controller: ${controller.text}, amount: $amount)';
}
