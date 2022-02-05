import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/dev/add_test_content.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';
import 'package:food_diary/features/diary/presentation/widgets/entry_form.dart';
import 'package:food_diary/features/settings/settings_page.dart';
import 'package:food_diary/generated/l10n.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key? key,
    required this.body,
    required this.onEntriesChange,
    required this.currentPage,
  }) : super(key: key);

  final Widget body;
  final void Function() onEntriesChange;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: body,
      bottomNavigationBar: _navigationBar(context),
      floatingActionButton: _addButtons(context),
    );
  }

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
                        entry: MealEntry(
                            dateTime: DateTime.now(), foods: const []),
                      )),
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

  BottomNavigationBar _navigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      items: [
        BottomNavigationBarItem(
            icon: const Icon(Icons.fastfood_outlined),
            label: AppLocalization.of(context).diaryBottomNavigationBarLabel),
        BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label:
                AppLocalization.of(context).calendarBottomNavigationBarLabel),
      ],
      onTap: (index) {},
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
