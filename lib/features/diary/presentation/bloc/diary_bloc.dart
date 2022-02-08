import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/generated/l10n.dart';

part 'diary_event.dart';
part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final DiaryFacadeService diaryFacadeService;
  final EntryFilter entryFilter;

  void onChangeCallback() {
    add(DiaryGetEntries());
  }

  DiaryBloc({
    required this.diaryFacadeService,
    required this.entryFilter,
  }) : super(const DiaryLoadInProgress([])) {
    diaryFacadeService.addOnChangeListener(onChangeCallback);

    on<DiaryGetEntries>((event, emit) async {
      emit(DiaryLoadInProgress(state.entries));
      List<DiaryEntry> entries = [];
      if (entryFilter.date != null && entryFilter.timespan != Timespan.all) {
        entries = (await diaryFacadeService
            .getAllDiaryEventsForMonth(entryFilter.date!));
        if (entryFilter.timespan == Timespan.month) {
          entries.removeWhere(
              (element) => element.dateTime.month != entryFilter.date!.month);
        } else if (entryFilter.timespan == Timespan.day) {
          entries.removeWhere(
              (element) => element.dateTime.day != entryFilter.date!.day);
        } else if (entryFilter.timespan == Timespan.week) {
          int offset = entryFilter.date!.weekday - 1;
          entries.removeWhere((element) =>
              element.dateTime.day < entryFilter.date!.day - offset ||
              element.dateTime.day >= entryFilter.date!.day - offset + 7);
        }
      } else {
        entries = (await diaryFacadeService.getAllDiaryEvents());
      }

      if (!entryFilter.meals) {
        entries.removeWhere((element) => element is MealEntry);
      }
      if (!entryFilter.symptoms) {
        entries.removeWhere((element) => element is SymptomEntry);
      }
      if (!entryFilter.bowelMovements) {
        entries.removeWhere((element) => element is BowelMovementEntry);
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
  final DateTime? date;
  final Timespan timespan;
  final bool meals;
  final bool symptoms;
  final bool bowelMovements;

  const EntryFilter({
    this.date,
    this.timespan = Timespan.all,
    this.meals = true,
    this.symptoms = true,
    this.bowelMovements = true,
  });

  factory EntryFilter.all() {
    return const EntryFilter(
        timespan: Timespan.all,
        meals: true,
        symptoms: true,
        bowelMovements: true);
  }
}

enum Timespan {
  all,
  month,
  week,
  day,
}

enum EntryType {
  meal,
  symptoms,
  bowelMovement,
}
