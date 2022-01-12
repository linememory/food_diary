import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:intl/intl.dart';

class MealList extends StatelessWidget {
  final List<Meal> meals;
  const MealList({Key? key, required this.meals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ListView(
        shrinkWrap: true,
        children: _mealItems(context, meals),
      ),
    );
  }

  List<Widget> _mealItems(BuildContext context, List<Meal> meals) {
    List<Widget> items = [];
    Meal? previousMeal;
    for (var meal in meals) {
      int microsecondsPerDay = (24 * 60 * 60 * 1000000);

      if (previousMeal == null ||
          meal.dateTime.microsecondsSinceEpoch ~/ microsecondsPerDay ==
              previousMeal.dateTime.microsecondsSinceEpoch ~/
                  microsecondsPerDay) {
        items.add(DateItem(dateTime: meal.dateTime));
      }
      items.add(MealListItem(time: meal.dateTime, foods: meal.foods));
      previousMeal = meal;
    }
    return items;
  }
}

class DateItem extends StatelessWidget {
  final DateTime dateTime;
  const DateItem({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEE, dd.mm.yyy');
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

class MealListItem extends StatelessWidget {
  MealListItem({Key? key, required this.time, required this.foods})
      : super(key: key);
  final DateTime time;
  final List<String> foods;
  final formatter = DateFormat('hh:mm');
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        formatter.format(time),
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
              ),
              const SizedBox(
                width: 100,
                child: Divider(
                  height: 10,
                  thickness: 1,
                ),
              ),
              EditButtons(time: time),
            ],
          ),
        ),
      ],
    );
  }

  Padding _foods() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: foods.map((food) => Text(food)).toList(),
      ),
    );
  }
}

class EditButtons extends StatelessWidget {
  final DateTime time;
  const EditButtons({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
            ),
            onPressed: () {},
            child: Text(
              "Update",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
            ),
            onPressed: () {
              BlocProvider.of<DiaryBloc>(context)
                  .add(DiaryDeleteMeal(time));
            },
            child: Text(
              "Delete",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
