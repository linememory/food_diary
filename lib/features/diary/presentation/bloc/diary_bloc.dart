import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/generated/l10n.dart';

part 'diary_event.dart';
part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final DiaryFacadeService diaryFacadeService;

  void onChangeCallback() {
    add(DiaryGetEntries());
  }

  DiaryBloc({
    required this.diaryFacadeService,
  }) : super(const DiaryLoadInProgress([])) {
    diaryFacadeService.addOnChangeListener(onChangeCallback);

    on<DiaryGetEntries>((event, emit) async {
      emit(DiaryLoadInProgress(state.entries));
      List<DiaryEntry> meals = (await diaryFacadeService.getAllDiaryEvents());
      meals.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      if (meals.isNotEmpty) {
        emit(DiaryLoadSuccess(meals));
      } else {
        emit(const DiaryEmpty());
      }
    });

    on<DiaryDeleteEntry>((event, emit) async {
      List<DiaryEntry> entries = List.from(state.entries);
      int index = entries.indexWhere((meal) => meal.id == event.id);

      if (index < 0) {
        var stateType = state.runtimeType;
        emit(DiaryDeleteFailure(
            state.entries, AppLocalization.current.diaryDeleteFailureNoMeal));
        emit(stateType == DiaryEmpty || state.entries.isEmpty
            ? const DiaryEmpty()
            : DiaryLoadSuccess(state.entries));
      } else {
        bool isDeleted = await diaryFacadeService.deleteDiaryEntry(event.id);
        if (isDeleted) {
          entries.removeAt(index);
          emit(entries.isNotEmpty
              ? DiaryLoadSuccess(entries)
              : const DiaryEmpty());
        } else {
          emit(DiaryDeleteFailure(state.entries,
              AppLocalization.current.diaryDeleteFailureNotDeleted));
          emit(state is DiaryEmpty || state.entries.isEmpty
              ? const DiaryEmpty()
              : DiaryLoadSuccess(state.entries));
        }
      }
    });
    add(DiaryGetEntries());
  }

  @override
  void onChange(Change<DiaryState> change) {
    log(change.toString(), name: runtimeType.toString());
    super.onChange(change);
  }

  @override
  Future<void> close() {
    diaryFacadeService.removeOnChangeListener(onChangeCallback);
    return super.close();
  }
}
