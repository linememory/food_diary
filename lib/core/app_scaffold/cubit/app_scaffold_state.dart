part of 'app_scaffold_cubit.dart';

abstract class AppScaffoldState extends Equatable {
  const AppScaffoldState(this.page);
  final int page;

  @override
  List<Object> get props => [page];
}

class AppScaffoldInitial extends AppScaffoldState {
  const AppScaffoldInitial(int page) : super(page);
}

class AppScaffoldPageChanged extends AppScaffoldState {
  const AppScaffoldPageChanged(int newPage) : super(newPage);
}
