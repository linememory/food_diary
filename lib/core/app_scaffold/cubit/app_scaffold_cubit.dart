import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_scaffold_state.dart';

class AppScaffoldCubit extends Cubit<AppScaffoldState> {
  AppScaffoldCubit() : super(AppScaffoldInitial());
}
