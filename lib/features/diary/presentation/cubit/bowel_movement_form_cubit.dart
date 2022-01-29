import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';
import 'package:food_diary/features/diary/presentation/cubit/entry_form_cubit.dart';

part 'bowel_movement_form_state.dart';

class BowelMovementFormCubit extends Cubit<BowelMovementFormState> {
  final EntryFormCubit _entryFormCubit;
  BowelMovementFormCubit(
      BowelMovementEntry? bowelMovementEntry, this._entryFormCubit)
      : super(
          BowelMovementFormInitial(bowelMovementEntry ??
              BowelMovementEntry(
                  dateTime: DateTime.now(),
                  bowelMovement: const BowelMovement(
                      stoolType: StoolType.type1, note: ""))),
        );

  void typeChanged(StoolType type) {
    BowelMovement bowelMovement =
        state.bowelMovementEntry.bowelMovement.copyWith(stoolType: type);
    emit(BowelMovementFormChanged(
        state.bowelMovementEntry.copyWith(bowelMovement: bowelMovement)));
    notifyEntryFormCubit(state.bowelMovementEntry);
  }

  void dateTimeChanged(DateTime newDateTime) {
    emit(BowelMovementFormChanged(
        state.bowelMovementEntry.copyWith(dateTime: newDateTime)));
    notifyEntryFormCubit(state.bowelMovementEntry);
  }

  void noteChanged(String note) {
    BowelMovement bowelMovement =
        state.bowelMovementEntry.bowelMovement.copyWith(note: note);
    emit(BowelMovementFormChanged(
        state.bowelMovementEntry.copyWith(bowelMovement: bowelMovement)));
    notifyEntryFormCubit(state.bowelMovementEntry);
  }

  void submit() {
    emit(BowelMovementFormSubmitted(state.bowelMovementEntry));
  }

  void notifyEntryFormCubit(BowelMovementEntry entry) {
    _entryFormCubit.formValid(entry.copyWith());
  }

  @override
  void onChange(Change<BowelMovementFormState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
