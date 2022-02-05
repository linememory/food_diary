import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_scaffold_state.dart';

class AppScaffoldCubit extends Cubit<AppScaffoldState> {
  AppScaffoldCubit() : super(const AppScaffoldInitial(0));

  void changePage(int newPage) {
    emit(AppScaffoldPageChanged(newPage));
  }
}
