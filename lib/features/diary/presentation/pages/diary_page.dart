import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/dev/add_test_content.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';
import 'package:food_diary/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:food_diary/features/diary/presentation/widgets/entry_form.dart';
import 'package:food_diary/features/diary/presentation/widgets/diary_list.dart';
import 'package:food_diary/generated/l10n.dart';
import 'package:food_diary/injection_container.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiaryBloc(diaryFacadeService: sl()),
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

  Padding _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, right: 8, left: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.background,
        ),
        child: BlocBuilder<DiaryBloc, DiaryState>(
          builder: _diaryBlocBuilder,
        ),
      ),
    );
  }

  Widget _diaryBlocBuilder(context, DiaryState state) {
    if (state is DiaryEmpty) {
      return Center(
        child: Text(state.message),
      );
    } else if (state is DiaryLoadInProgress) {
      return const Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return DiaryList(entries: state.entries);
    }
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(S.of(context).diaryPageTitle),
      toolbarHeight: MediaQuery.of(context).size.height / 12,
      leading: const Icon(Icons.fastfood),
      elevation: 5,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
        IconButton(
          onPressed: () async {
            await addTestContent(
                seed: 0,
                mealsCount: 10,
                symptomsCount: 10,
                bowelMovementCount: 10);
            BlocProvider.of<DiaryBloc>(context).add(DiaryGetEntries());
          },
          icon: const Icon(Icons.add),
        ),
        IconButton(
          onPressed: () async {
            await deleteTestContent();
            BlocProvider.of<DiaryBloc>(context).add(DiaryGetEntries());
          },
          icon: const Icon(Icons.delete),
        ),
      ],
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
          tooltip: S.of(context).addMealTooltip,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EntryForm(
                        entry: MealEntry(
                            dateTime: DateTime.now(), foods: const []),
                      )),
            );
            BlocProvider.of<DiaryBloc>(context).add(DiaryGetEntries());
          },
          child: Row(children: const [
            Icon(Icons.add),
            Icon(Icons.fastfood),
          ]),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        FloatingActionButton(
          heroTag: "AddSymptom",
          tooltip: S.of(context).addSymptomTooltip,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EntryForm(
                        entry: SymptomEntry(
                            dateTime: DateTime.now(), symptoms: const []),
                      )),
            );
            BlocProvider.of<DiaryBloc>(context).add(DiaryGetEntries());
          },
          child: Row(children: const [
            Icon(Icons.add),
            Icon(Icons.sick),
          ]),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        FloatingActionButton(
          heroTag: "AddBowelMovement",
          tooltip: S.of(context).addBowelMovementTooltip,
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
            BlocProvider.of<DiaryBloc>(context).add(DiaryGetEntries());
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
      items: [
        BottomNavigationBarItem(
            icon: const Icon(Icons.fastfood_outlined),
            label: S.of(context).diaryBottomNavigationBarLabel),
        BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: S.of(context).calendarBottomNavigationBarLabel),
      ],
      onTap: (index) {},
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
