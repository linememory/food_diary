import 'package:flutter/material.dart';
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
    required this.year,
    required this.month,
  }) : super(key: key);

  final int year;
  final int month;

  @override
  Widget build(BuildContext context) {
    DateTime firstDayDateTime = DateTime(year, month);
    int start = firstDayDateTime.weekday - 1;
    int daysInMonth = DateTimeRange(
            start: DateTime(year, month), end: DateTime(year, month + 1))
        .duration
        .inDays;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Text(
              DateFormat.MMMM().format(firstDayDateTime),
              style: Theme.of(context).textTheme.headline3,
            ),
            IconButton(
              onPressed: () {},
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
          child: GridView.count(
              //childAspectRatio: 0.75,
              crossAxisCount: 7,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              children: List.generate(start, (i) {
                return Container();
              })
                ..addAll(
                  List.generate(
                    daysInMonth,
                    (i) => DayItem(
                      day: i + 1,
                      onPressed: () {},
                    ),
                  ).toList(),
                )),
        ),
      ],
    );
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade500, width: 3),
        borderRadius: BorderRadius.circular(100),
        color: isDisabled
            ? Theme.of(context).disabledColor
            : Theme.of(context).colorScheme.primary,
      ),
      child: Center(child: Text(day.toString())),
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
