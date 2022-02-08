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
  final EntryFilter? entryFilter;

  void onChangeCallback() {
    add(DiaryGetEntries());
  }

  DiaryBloc({
    required this.diaryFacadeService,
    this.entryFilter,
  }) : super(const DiaryLoadInProgress([])) {
    diaryFacadeService.addOnChangeListener(onChangeCallback);

    on<DiaryGetEntries>((event, emit) async {
      emit(DiaryLoadInProgress(state.entries));
      List<DiaryEntry> entries = [];
      if (entryFilter != null) {
        entries = (await diaryFacadeService
            .getAllDiaryEventsForMonth(entryFilter!.date));
        if (entryFilter!.timespan == Timespan.month) {
          entries.removeWhere(
              (element) => element.dateTime.month != entryFilter!.date.month);
        } else if (entryFilter!.timespan == Timespan.day) {
          entries.removeWhere(
              (element) => element.dateTime.day != entryFilter!.date.day);
        } else if (entryFilter!.timespan == Timespan.week) {
          int offset = entryFilter!.date.weekday - 1;
          entries.removeWhere((element) =>
              element.dateTime.day < entryFilter!.date.day - offset ||
              element.dateTime.day >= entryFilter!.date.day - offset + 7);
        }
      } else {
        entries = (await diaryFacadeService.getAllDiaryEvents());
      }

      entries.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      if (entries.isNotEmpty) {
        emit(DiaryLoadSuccess(entries));
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

class EntryFilter {
  final DateTime date;
  final Timespan timespan;

  EntryFilter(this.date, this.timespan);
}

enum Timespan {
  month,
  week,
  day,
}
