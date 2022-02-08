import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/core/app_scaffold/cubit/app_scaffold_cubit.dart';
import 'package:food_diary/dev/add_test_content.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';
import 'package:food_diary/features/diary/presentation/pages/calendar_page.dart';
import 'package:food_diary/features/diary/presentation/pages/diary_page.dart';
import 'package:food_diary/features/diary/presentation/widgets/entry_form.dart';
import 'package:food_diary/features/settings/settings_page.dart';
import 'package:food_diary/generated/l10n.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppScaffoldCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: _appBar(context),
          body: _body(context),
          bottomNavigationBar: _navigationBar(context),
          floatingActionButton: _addButtons(context),
        );
      }),
    );
  }

  Widget _body(context) => BlocBuilder<AppScaffoldCubit, AppScaffoldState>(
        builder: (context, state) {
          if (state.page == 0) {
            return const DiaryPage();
          } else if (state.page == 1) {
            return const CalendarPage();
          }
          return Container();
        },
      );

  AppBar _appBar(BuildContext context) {
    List<Widget> actions = [
      IconButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        },
        icon: const Icon(Icons.settings),
      ),
    ];
    if (kDebugMode) {
      List<Widget> dev = [
        IconButton(
          onPressed: () async {
            await addTestContent(
                seed: 0,
                mealsCount: 10,
                symptomsCount: 10,
                bowelMovementCount: 10);
          },
          icon: const Icon(Icons.add),
        ),
        IconButton(
          onPressed: () async {
            await deleteTestContent();
          },
          icon: const Icon(Icons.delete),
        ),
      ];
      actions.addAll(dev);
    }
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(AppLocalization.of(context).diaryPageTitle),
      toolbarHeight: MediaQuery.of(context).size.height / 12,
      leading: const Icon(Icons.fastfood),
      elevation: 5,
      actions: actions,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(24, 24),
        ),
      ),
    );
  }

  Widget _addButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "AddMeal",
          tooltip: AppLocalization.of(context).addMealTooltip,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EntryForm(
                  entry: MealEntry(dateTime: DateTime.now(), foods: const []),
                ),
              ),
            );
          },
          child: Row(children: const [
            Icon(Icons.add),
            Icon(Icons.fastfood),
          ]),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        FloatingActionButton(
          heroTag: "AddSymptom",
          tooltip: AppLocalization.of(context).addSymptomTooltip,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EntryForm(
                        entry: SymptomEntry(
                            dateTime: DateTime.now(), symptoms: const []),
                      )),
            );
          },
          child: Row(children: const [
            Icon(Icons.add),
            Icon(Icons.sick),
          ]),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        FloatingActionButton(
          heroTag: "AddBowelMovement",
          tooltip: AppLocalization.of(context).addBowelMovementTooltip,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EntryForm(
                        entry: BowelMovementEntry(
                            dateTime: DateTime.now(),
                            bowelMovement: const BowelMovement(
                                stoolType: StoolType.type1, note: "")),
                      )),
            );
          },
          child: Row(children: const [
            Icon(Icons.add),
            Icon(Icons.wc),
          ]),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _navigationBar(BuildContext context) {
    return BlocBuilder<AppScaffoldCubit, AppScaffoldState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.page,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.fastfood_outlined),
              label: AppLocalization.of(context).diaryBottomNavigationBarLabel,
              backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
            ),
            BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_today),
                label: AppLocalization.of(context)
                    .calendarBottomNavigationBarLabel,
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryVariant),
          ],
          onTap: (index) {
            BlocProvider.of<AppScaffoldCubit>(context).changePage(index);
          },
          backgroundColor: Theme.of(context).primaryColor,
        );
      },
    );
  }
}
