import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
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
        items.add(DateItem(dateTime: entry.dateTime));
      }
      if (entry is MealEntry) {
        items.add(MealListItem(meal: entry));
      } else if (entry is SymptomEntry) {
        items.add(SymptomListItem(symptoms: entry));
      }
      previousEntry = entry;
    }
    return items;
  }
}

class DateItem extends StatelessWidget {
  final DateTime dateTime;
  const DateItem({Key? key, required this.dateTime}) : super(key: key);

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

class EntryItem2 extends StatelessWidget {
  const EntryItem2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MealListItem extends StatelessWidget {
  MealListItem({Key? key, required this.meal}) : super(key: key);
  final MealEntry meal;

  final formatter = DateFormat('HH:mm');
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
          _dateAndFoods(context),
          const SizedBox(
            width: 100,
            child: Divider(
              height: 10,
              thickness: 1,
            ),
          ),
          EditButtons(entryItem: meal),
        ],
      ),
    );
  }

  IntrinsicHeight _dateAndFoods(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              formatter.format(meal.dateTime),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          const VerticalDivider(
            width: 10,
            thickness: 2,
          ),
          _foods(),
        ],
      ),
    );
  }

  Widget _foods() {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: meal.foods
            .map(
              (food) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            food.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        //Flexible(flex: 0, fit: FlexFit.tight, child: Container()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                              "${food.amount.name[0].toUpperCase()}${food.amount.name.substring(1)}"),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 2,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class SymptomListItem extends StatelessWidget {
  SymptomListItem({Key? key, required this.symptoms}) : super(key: key);
  final SymptomEntry symptoms;

  final formatter = DateFormat('HH:mm');
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
          _dateAndFoods(context),
          const SizedBox(
            width: 100,
            child: Divider(
              height: 10,
              thickness: 1,
            ),
          ),
          EditButtons(entryItem: symptoms),
        ],
      ),
    );
  }

  IntrinsicHeight _dateAndFoods(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _symptoms(),
          const VerticalDivider(
            width: 10,
            thickness: 2,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              formatter.format(symptoms.dateTime),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _symptoms() {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: symptoms.symptoms
            .map(
              (symptom) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            symptom.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        //Flexible(flex: 0, fit: FlexFit.tight, child: Container()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                              "${symptom.intensity.name[0].toUpperCase()}${symptom.intensity.name.substring(1)}"),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 2,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class EditButtons extends StatelessWidget {
  final DiaryEntry entryItem;
  EditButtons({
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
