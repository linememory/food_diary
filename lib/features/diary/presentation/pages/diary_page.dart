import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:food_diary/features/diary/presentation/widgets/diary_list.dart';
import 'package:food_diary/injection_container.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiaryBloc(diaryFacadeService: sl()),
      child: Builder(builder: (context) {
        return _body(context);
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
}
