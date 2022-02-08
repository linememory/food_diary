import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:food_diary/features/diary/presentation/cubit/calendar/calendar_cubit.dart';
import 'package:food_diary/features/diary/presentation/pages/diary_page.dart';
import 'package:food_diary/injection_container.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Calendar(
        year: 2022,
        month: 2,
      ),
    );
  }
}

class Calendar extends StatelessWidget {
  const Calendar({
    Key? key,
    this.year,
    this.month,
  }) : super(key: key);

  final int? year;
  final int? month;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarCubit(sl(), year, month),
      child: Builder(builder: (context) {
        return BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            DateTime firstDayDateTime = DateTime(state.year, state.month);
            int start = firstDayDateTime.weekday - 1;
            int daysInMonth = DateTimeRange(
                    start: DateTime(state.year, state.month),
                    end: DateTime(state.year, state.month + 1))
                .duration
                .inDays;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => BlocProvider.of<CalendarCubit>(context)
                          .previousMonth(),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Column(
                      children: [
                        Text(
                          firstDayDateTime.year.toString(),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text(
                          DateFormat.MMMM().format(firstDayDateTime),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () =>
                          BlocProvider.of<CalendarCubit>(context).nextMonth(),
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      WeekdayHeader(
                        weekday: Weekday.monday(),
                      ),
                      WeekdayHeader(
                        weekday: Weekday.tuesday(),
                      ),
                      WeekdayHeader(
                        weekday: Weekday.wednesday(),
                      ),
                      WeekdayHeader(
                        weekday: Weekday.thursday(),
                      ),
                      WeekdayHeader(
                        weekday: Weekday.friday(),
                      ),
                      WeekdayHeader(
                        weekday: Weekday.saturday(),
                      ),
                      WeekdayHeader(
                        weekday: Weekday.sunday(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GridView.count(
                      childAspectRatio: 1,
                      crossAxisCount: 7,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      shrinkWrap: true,
                      children: List.generate(start, (i) {
                        return Container();
                      })
                        ..addAll(
                          List.generate(
                            daysInMonth,
                            (i) {
                              if (state.entries.indexWhere((element) =>
                                      element.dateTime.day == i + 1) ==
                                  -1) {
                                return DayItem(
                                  day: i + 1,
                                  isDisabled: true,
                                  onPressed: () {},
                                );
                              } else {
                                return DayItem(
                                  day: i + 1,
                                  isDisabled: false,
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DayView(
                                          dateTime: DateTime(
                                              state.year, state.month, i + 1),
                                          entries: state.entries
                                              .where((element) =>
                                                  element.dateTime.day == i + 1)
                                              .toList(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ).toList(),
                        )),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}

class DayView extends StatelessWidget {
  const DayView({
    Key? key,
    required this.dateTime,
    required this.entries,
  }) : super(key: key);

  final DateTime dateTime;
  final List<DiaryEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DateFormat.yMMMMEEEEd().format(dateTime)),
        ),
        body: DiaryPage(entryFilter: EntryFilter(dateTime, Timespan.week)));
  }
}

class DayItem extends StatelessWidget {
  const DayItem({
    Key? key,
    required this.day,
    required this.onPressed,
    this.isDisabled = false,
  }) : super(key: key);

  final int day;
  final bool isDisabled;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade500, width: 3),
          borderRadius: BorderRadius.circular(100),
          color: isDisabled
              ? Theme.of(context).disabledColor
              : Theme.of(context).colorScheme.primary,
        ),
        child: Center(child: Text(day.toString())),
      ),
    );
  }
}

class WeekdayHeader extends StatelessWidget {
  const WeekdayHeader({
    Key? key,
    required this.weekday,
  }) : super(key: key);

  final Weekday weekday;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(1),
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primaryVariant,
          ),
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(child: Text(weekday.toString())),
      ),
    );
  }
}

class Weekday {
  final int weekday;

  Weekday._internal(this.weekday);

  static Weekday monday() => Weekday._internal(0);
  static Weekday tuesday() => Weekday._internal(1);
  static Weekday wednesday() => Weekday._internal(2);
  static Weekday thursday() => Weekday._internal(3);
  static Weekday friday() => Weekday._internal(4);
  static Weekday saturday() => Weekday._internal(5);
  static Weekday sunday() => Weekday._internal(6);

  @override
  String toString() {
    return DateFormat.E().format(DateTime.fromMillisecondsSinceEpoch(
        (weekday + 4) * 1000 * 60 * 60 * 24));
  }
}
