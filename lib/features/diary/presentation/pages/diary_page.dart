import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/dev/add_test_content.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:food_diary/features/diary/presentation/widgets/meal_form.dart';
import 'package:food_diary/features/diary/presentation/widgets/meal_list.dart';
import 'package:food_diary/injection_container.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DiaryBloc>(),
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
            color: Theme.of(context).colorScheme.background),
        child: BlocBuilder<DiaryBloc, DiaryState>(
          builder: _diaryBlocBuilder,
        ),
      ),
    );
  }

  Widget _diaryBlocBuilder(context, state) {
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
      return MealList(meals: state.meals);
    }
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text("Food Diary"),
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
            await addTestContent(seed: 0);
            BlocProvider.of<DiaryBloc>(context).add(DiaryGetMeals());
          },
          icon: const Icon(Icons.add),
        ),
        IconButton(
          onPressed: () async {
            await deleteTestContent();
            BlocProvider.of<DiaryBloc>(context).add(DiaryGetMeals());
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
          heroTag: "MealAdd",
          onPressed: () async {
            Meal? meal = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MealForm()),
            );
            if (meal != null) {
              BlocProvider.of<DiaryBloc>(context).add(DiaryAddMeal(meal));
            }
          },
          child: Row(children: const [
            Icon(Icons.add),
            Icon(Icons.fastfood),
          ]),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        FloatingActionButton(
          heroTag: "SymptomAdd",
          onPressed: () {},
          child: Row(children: const [
            Icon(Icons.add),
            Icon(Icons.sick),
          ]),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }

  BottomNavigationBar _navigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined), label: "Food Diary"),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_sharp), label: "Evaluation"),
      ],
      onTap: (index) {},
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
