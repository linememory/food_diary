part of 'calendar_cubit.dart';

abstract class CalendarState extends Equatable {
  const CalendarState(
    this.year,
    this.month,
    this.entries,
  );

  final int year;
  final int month;
  final List<DiaryEntry> entries;

  @override
  List<Object> get props => [year, month, entries];
}

class CalendarInitial extends CalendarState {
  const CalendarInitial(int year, int month, List<DiaryEntry> entries)
      : super(year, month, entries);
}

class CalendarChanged extends CalendarState {
  const CalendarChanged(int year, int month, List<DiaryEntry> entries)
      : super(year, month, entries);
}
