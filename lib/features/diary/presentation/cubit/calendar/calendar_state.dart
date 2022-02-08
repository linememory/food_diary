part of 'calendar_cubit.dart';

abstract class CalendarState extends Equatable {
  const CalendarState(
    this.year,
    this.month,
  );

  final int year;
  final int month;

  @override
  List<Object> get props => [month];
}

class CalendarInitial extends CalendarState {
  const CalendarInitial(int year, int month) : super(year, month);
}

class CalendarMonthChanged extends CalendarState {
  const CalendarMonthChanged(int year, int month) : super(year, month);
}
