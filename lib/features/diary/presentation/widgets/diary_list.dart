import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
import 'package:food_diary/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:food_diary/features/diary/presentation/widgets/entry_form.dart';
import 'package:intl/intl.dart';

class DiaryList extends StatelessWidget {
  final List<DiaryEntry> entries;
  const DiaryList({Key? key, required this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ListView(
        shrinkWrap: true,
        children: _entryItems(context, entries),
      ),
    );
  }

  List<Widget> _entryItems(BuildContext context, List<DiaryEntry> entries) {
    List<Widget> items = [];
    DiaryEntry? previousEntry;
    bool sameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;
    for (var entry in entries) {
      if (previousEntry == null ||
          !sameDay(entry.dateTime, previousEntry.dateTime)) {
        items.add(_DateItem(dateTime: entry.dateTime));
      }
      items.add(_EntryItem(
        meal: entry,
      ));
      previousEntry = entry;
    }
    return items;
  }
}

class _DateItem extends StatelessWidget {
  final DateTime dateTime;
  const _DateItem({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEE, dd.MM.yyy');
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        formatter.format(dateTime),
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}

class _EntryItem extends StatelessWidget {
  const _EntryItem({Key? key, required this.meal}) : super(key: key);

  final DiaryEntry meal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Column(
        children: [
          _EntryContent(entry: meal),
          const SizedBox(
            width: 100,
            child: Divider(
              height: 10,
              thickness: 1,
            ),
          ),
          _EditButtons(entryItem: meal),
        ],
      ),
    );
  }
}

class _EditButtons extends StatelessWidget {
  final DiaryEntry entryItem;
  _EditButtons({
    Key? key,
    required this.entryItem,
  })  : assert(entryItem.id != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(0, 0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: buttonStyle,
          child: _buttonText(context, "Update"),
          onPressed: () async {
            if (entryItem is MealEntry) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MealForm(
                          type: FormType.updateMeal,
                          meal: entryItem as MealEntry,
                        )),
              );
            }
            BlocProvider.of<DiaryBloc>(context).add(DiaryGetEntries());
          },
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          style: buttonStyle,
          child: _buttonText(context, "Delete"),
          onPressed: () {
            BlocProvider.of<DiaryBloc>(context)
                .add(DiaryDeleteEntry(entryItem.id!));
          },
        ),
      ],
    );
  }

  Text _buttonText(BuildContext context, String buttonText) {
    return Text(
      buttonText,
      style: Theme.of(context)
          .textTheme
          .bodyText1!
          .copyWith(fontSize: 12, fontWeight: FontWeight.normal),
    );
  }
}

class _EntryContent extends StatelessWidget {
  const _EntryContent({Key? key, required this.entry}) : super(key: key);

  final DiaryEntry entry;

  final VerticalDivider divider = const VerticalDivider(
    width: 10,
    thickness: 2,
  );

  Widget _itemList(List<Widget> children) => Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (entry is MealEntry) {
      return IntrinsicHeight(
        child: Row(
          children: _mealEntry(entry as MealEntry),
        ),
      );
    } else if (entry is SymptomEntry) {
      return IntrinsicHeight(
        child: Row(
          children: _symptomEntry(entry as SymptomEntry),
        ),
      );
    } else if (entry is BowelMovementEntry) {
      return IntrinsicHeight(
        child: Row(
          children: _bowelMovementEntry(entry as BowelMovementEntry),
        ),
      );
    } else {
      return Container();
    }
  }

  List<Widget> _mealEntry(MealEntry meal) {
    return [
      _EntryTime(
        time: TimeOfDay.fromDateTime(meal.dateTime),
      ),
      divider,
      _itemList(meal.foods
          .map((food) => _ItemLine(
                left: food.name,
                right:
                    "${food.amount.name[0].toUpperCase()}${food.amount.name.substring(1)}",
              ))
          .toList()),
    ];
  }

  List<Widget> _symptomEntry(SymptomEntry symptomEntry) {
    return [
      _itemList(symptomEntry.symptoms
          .map((symptom) => _ItemLine(
              left: symptom.name,
              right:
                  "${symptom.intensity.name[0].toUpperCase()}${symptom.intensity.name.substring(1)}"))
          .toList()),
      divider,
      _EntryTime(
        time: TimeOfDay.fromDateTime(symptomEntry.dateTime),
      ),
    ];
  }

  List<Widget> _bowelMovementEntry(BowelMovementEntry bowelMovementEntry) {
    return [
      _itemList([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(bowelMovementEntry.bowelMovement.stoolType.name),
              const SizedBox(
                height: 20,
                child: VerticalDivider(
                  width: 5,
                ),
              ),
              Expanded(
                child: Text(
                  bowelMovementEntry.bowelMovement.note,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ]),
      divider,
      _EntryTime(
        time: TimeOfDay.fromDateTime(bowelMovementEntry.dateTime),
      ),
    ];
  }
}

class _ItemLine extends StatelessWidget {
  const _ItemLine({
    Key? key,
    required this.left,
    required this.right,
  }) : super(key: key);

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(right),
              ),
            ],
          ),
          const Divider(
            height: 2,
          ),
        ],
      ),
    );
  }
}

class _EntryTime extends StatelessWidget {
  const _EntryTime({
    Key? key,
    required this.time,
  }) : super(key: key);

  final TimeOfDay time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        time.format(context).toString(),
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
