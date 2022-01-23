import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:food_diary/features/diary/presentation/widgets/meal_form.dart';
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
    bool sameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;
    for (var meal in meals) {
      if (previousMeal == null ||
          !sameDay(meal.dateTime, previousMeal.dateTime)) {
        items.add(DateItem(dateTime: meal.dateTime));
      }
      items.add(MealListItem(meal: meal));
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

class MealListItem extends StatelessWidget {
  MealListItem({Key? key, required this.meal}) : super(key: key);
  final Meal meal;

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
          EditButtons(meal: meal),
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

class EditButtons extends StatelessWidget {
  final Meal meal;
  EditButtons({Key? key, 
    required this.meal,
  }): assert(meal.id != null), super(key: key);

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
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MealForm(
                        type: FormType.updateMeal,
                        meal: meal,
                      )),
            );
            BlocProvider.of<DiaryBloc>(context).add(DiaryGetMeals());
          },
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          style: buttonStyle,
          child: _buttonText(context, "Delete"),
          onPressed: () {
            BlocProvider.of<DiaryBloc>(context).add(DiaryDeleteMeal(meal.id!));
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
