import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/bowel_movement_item.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/entry_item.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/meal_item.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/symptom_item.dart';

part 'diary_event.dart';
part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final DiaryFacadeService diaryFacadeService;

  DiaryBloc({required this.diaryFacadeService})
      : super(const DiaryLoadInProgress([])) {
    on<DiaryGetEntries>((event, emit) async {
      emit(DiaryLoadInProgress(state.entries));
      List<EntryItem> meals = (await diaryFacadeService.getAllDiaryEvents())
          .map((e) => fromEntity(e))
          .toList();
      meals.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      if (meals.isNotEmpty) {
        emit(DiaryLoadSuccess(meals));
      } else {
        emit(const DiaryEmpty());
      }
    });

    on<DiaryAddEntry>((event, emit) async {
      bool isAdded =
          await diaryFacadeService.addDiaryEntry(event.entry.toEntity());
      if (isAdded) {
        List<EntryItem> entries = List.from(state.entries);
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
      List<EntryItem> entries = state.entries;
      int index = entries.indexWhere((meal) => meal.id == event.entry.id);
      if (index >= 0) {
        bool isUpdated =
            await diaryFacadeService.updateDiaryEntry(event.entry.toEntity());
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
      List<MealItem> meals = List.from(state.entries);
      int index = meals.indexWhere((meal) => meal.id == event.id);

      if (index < 0) {
        var stateType = state.runtimeType;
        emit(DiaryDeleteFailure(state.entries, "No meal to delete"));
        emit(stateType == DiaryEmpty || state.entries.isEmpty
            ? const DiaryEmpty()
            : DiaryLoadSuccess(state.entries));
      } else {
        bool isDeleted = await diaryFacadeService.deleteDiaryEntry(event.id);
        if (isDeleted) {
          meals.removeAt(index);
          emit(meals.isNotEmpty ? DiaryLoadSuccess(meals) : const DiaryEmpty());
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

  EntryItem fromEntity(DiaryEntry entry) {
    if (entry is MealEntry) {
      return MealItem.fromEntity(entry);
    } else if (entry is SymptomEntry) {
      return SymptomsItem.fromEntity(entry);
    } else if (entry is BowelMovementEntry) {
      return BowelMovementItem.fromEntity(entry);
    } else {
      throw Exception("Not a valid entry");
    }
  }
}
