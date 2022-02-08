import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit()
      : super(CalendarInitial(DateTime.now().year, DateTime.now().month));

  void nextMonth() {
    int nextMonth = ((state.month) % 11) + 1;
    int nextYear = nextMonth < state.month ? state.year + 1 : state.year;
    emit(CalendarMonthChanged(nextYear, nextMonth));
  }

  void previousMonth() {
    int nextMonth = state.month - 1 < 1 ? 12 : state.month - 1;
    int nextYear = nextMonth > state.month ? state.year - 1 : state.year;
    emit(CalendarMonthChanged(nextYear, nextMonth));
  }
}
