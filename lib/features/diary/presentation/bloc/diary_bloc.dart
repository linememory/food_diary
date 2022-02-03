import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';

part 'diary_event.dart';
part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final DiaryFacadeService diaryFacadeService;

  DiaryBloc({required this.diaryFacadeService})
      : super(const DiaryLoadInProgress([])) {
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

    on<DiaryAddEntry>((event, emit) async {
      bool isAdded = await diaryFacadeService.addDiaryEntry(event.entry);
      if (isAdded) {
        List<DiaryEntry> entries = List.from(state.entries);
        int index = entries.indexWhere(
            (element) => element.dateTime.isAfter(event.entry.dateTime));
        entries.insert(index > -1 ? index : 0, event.entry);
        emit(DiaryLoadSuccess(entries));
      } else {
        var stateType = state.runtimeType;
        emit(DiaryAddFailure(state.entries, "Meal could not be added"));
        emit(stateType == DiaryEmpty
            ? const DiaryEmpty()
            : DiaryLoadSuccess(state.entries));
      }
    });

    on<DiaryUpdateEntry>((event, emit) async {
      List<DiaryEntry> entries = state.entries;
      int index = entries.indexWhere((meal) => meal.id == event.entry.id);
      if (index >= 0) {
        bool isUpdated = await diaryFacadeService.updateDiaryEntry(event.entry);
        if (isUpdated) {
          entries[index] = event.entry;
          emit(DiaryLoadSuccess(List.from(entries)));
        } else {
          var stateType = state.runtimeType;
          emit(DiaryUpdateFailure(state.entries, "Meal could not be updated"));
          emit(stateType == DiaryEmpty
              ? const DiaryEmpty()
              : DiaryLoadSuccess(state.entries));
        }
      } else {
        var stateType = state.runtimeType;
        emit(DiaryUpdateFailure(entries, "No meal to update"));
        emit(stateType == DiaryEmpty
            ? const DiaryEmpty()
            : DiaryLoadSuccess(state.entries));
      }
    });

    on<DiaryDeleteEntry>((event, emit) async {
      List<DiaryEntry> entries = List.from(state.entries);
      int index = entries.indexWhere((meal) => meal.id == event.id);

      if (index < 0) {
        var stateType = state.runtimeType;
        emit(DiaryDeleteFailure(state.entries, "No meal to delete"));
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
          var stateType = state.runtimeType;
          emit(DiaryDeleteFailure(state.entries, "Meal could not be deleted"));
          emit(stateType == DiaryEmpty || state.entries.isEmpty
              ? const DiaryEmpty()
              : DiaryLoadSuccess(state.entries));
        }
      }
    });
    add(DiaryGetEntries());
  }

  @override
  void onChange(Change<DiaryState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
