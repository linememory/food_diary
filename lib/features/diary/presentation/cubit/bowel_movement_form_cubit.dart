import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';
import 'package:food_diary/features/diary/presentation/cubit/entry_form_cubit.dart';

part 'bowel_movement_form_state.dart';

class BowelMovementFormCubit extends Cubit<BowelMovementFormState> {
  final EntryFormCubit _entryFormCubit;
  BowelMovementFormCubit(
      BowelMovementEntry? bowelMovementEntry, this._entryFormCubit)
      : super(
          BowelMovementFormInitial(
            Data.fromEntity(
              bowelMovementEntry ??
                  BowelMovementEntry(
                    dateTime: DateTime.now(),
                    bowelMovement: const BowelMovement(
                        stoolType: StoolType.type1, note: ""),
                  ),
            ),
          ),
        );

  void dateTimeChanged(DateTime newDateTime) {
    emit(BowelMovementFormChanged(state.data.copyWith(dateTime: newDateTime)));
    notifyEntryFormCubit(state.data);
  }

  void noteChanged(String note) {
    Data newData = Data.from(state.data);
    emit(BowelMovementFormChanged(newData));
    notifyEntryFormCubit(newData);
  }

  void typeChanged(StoolType type) {
    Data newData = Data.from(state.data);
    newData.field.stoolType = type;

    emit(BowelMovementFormChanged(newData));
    notifyEntryFormCubit(newData);
  }

  void submit() {
    emit(BowelMovementFormSubmitted(state.data));
  }

  void notifyEntryFormCubit(Data newData) {
    BowelMovementEntry entry = newData.toEntity();
    _entryFormCubit.formValid(entry);
  }

  @override
  void onChange(Change<BowelMovementFormState> change) {
    log(change.toString());
    super.onChange(change);
  }
}

class Data {
  final int? id;
  final DateTime dateTime;
  final Field field;
  Data({
    this.id,
    required this.dateTime,
    required this.field,
  });

  Data.from(Data data)
      : id = data.id,
        dateTime = data.dateTime,
        field = data.field;

  Data.fromEntity(BowelMovementEntry bowelMovementEntry)
      : id = bowelMovementEntry.id,
        dateTime = bowelMovementEntry.dateTime,
        field = Field(
            controller: TextEditingController(
                text: bowelMovementEntry.bowelMovement.note),
            stoolType: bowelMovementEntry.bowelMovement.stoolType);

  Data copyWith({
    final int? id,
    final DateTime? dateTime,
    final Field? field,
  }) {
    return Data(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      field: field ?? this.field,
    );
  }

  BowelMovementEntry toEntity() {
    BowelMovement bowelMovement =
        BowelMovement(note: field.controller.text, stoolType: field.stoolType);

    return BowelMovementEntry(
        id: id, dateTime: dateTime, bowelMovement: bowelMovement);
  }
}

class Field {
  TextEditingController controller;
  StoolType stoolType;
  Field({
    required this.controller,
    required this.stoolType,
  });

  Field copyWith({
    TextEditingController? controller,
    StoolType? stoolType,
  }) {
    return Field(
      controller: controller ?? this.controller,
      stoolType: stoolType ?? this.stoolType,
    );
  }
}
