import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/dev/add_test_content.dart';
import 'package:food_diary/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:food_diary/features/diary/presentation/widgets/meal_list.dart';
import 'package:food_diary/injection_container.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DiaryBloc>(),
      child: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Diary"),
        toolbarHeight: MediaQuery.of(context).size.height / 8,
        leading: const Icon(Icons.fastfood),
        elevation: 5,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(24, 24),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<DiaryBloc, DiaryState>(
          builder: (context, state) {
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
          },
        ),
      ),
    );
  }
}
