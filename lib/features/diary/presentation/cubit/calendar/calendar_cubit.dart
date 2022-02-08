import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  DiaryFacadeService diaryFacadeService;

  void onChangeCallback() {
    reload();
  }

  CalendarCubit(this.diaryFacadeService, int? year, int? month)
      : super(CalendarInitial(year ?? DateTime.now().year,
            month ?? DateTime.now().month, const [])) {
    reload();
    diaryFacadeService.addOnChangeListener(onChangeCallback);
  }

  void nextMonth() async {
    int nextMonth = ((state.month) % 11) + 1;
    int nextYear = nextMonth < state.month ? state.year + 1 : state.year;
    List<DiaryEntry> entries = await diaryFacadeService
        .getAllDiaryEventsForMonth((DateTime(nextYear, nextMonth)));
    emit(CalendarChanged(nextYear, nextMonth, entries));
  }

  void previousMonth() async {
    int nextMonth = state.month - 1 < 1 ? 12 : state.month - 1;
    int nextYear = nextMonth > state.month ? state.year - 1 : state.year;
    List<DiaryEntry> entries = await diaryFacadeService
        .getAllDiaryEventsForMonth((DateTime(nextYear, nextMonth)));
    emit(CalendarChanged(nextYear, nextMonth, entries));
  }

  void reload() async {
    List<DiaryEntry> entries = await diaryFacadeService
        .getAllDiaryEventsForMonth((DateTime(state.year, state.month)));
    emit(CalendarChanged(state.year, state.month, entries));
  }

  @override
  void onChange(Change<CalendarState> change) {
    log(change.toString(), name: runtimeType.toString());
    super.onChange(change);
  }

  @override
  Future<void> close() {
    diaryFacadeService.removeOnChangeListener(onChangeCallback);
    return super.close();
  }
}
