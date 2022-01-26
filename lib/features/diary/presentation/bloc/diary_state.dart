part of 'diary_bloc.dart';

abstract class DiaryState extends Equatable {
  final List<EntryItem> entries;
  const DiaryState(this.entries);

  @override
  List<Object> get props => [entries];

  @override
  String toString() => '$runtimeType (meals: ${entries.length})';
}

class DiaryLoadInProgress extends DiaryState {
  const DiaryLoadInProgress(List<EntryItem> meals) : super(meals);
}

class DiaryLoadSuccess extends DiaryState {
  const DiaryLoadSuccess(List<EntryItem> entries) : super(entries);
}

class DiaryEmpty extends DiaryState {
  final String message = "No meals tracked";

  const DiaryEmpty() : super(const []);

  @override
  List<Object> get props => [entries, message];
}

class DiaryFailure extends DiaryState {
  final String reason;

  const DiaryFailure(List<EntryItem> meals, this.reason) : super(meals);

  @override
  List<Object> get props => [entries, reason];
}

class DiaryAddFailure extends DiaryFailure {
  const DiaryAddFailure(List<EntryItem> meals, String reason)
      : super(meals, reason);
}

class DiaryUpdateFailure extends DiaryFailure {
  const DiaryUpdateFailure(List<EntryItem> meals, String reason)
      : super(meals, reason);
}

class DiaryDeleteFailure extends DiaryFailure {
  const DiaryDeleteFailure(List<EntryItem> meals, String reason)
      : super(meals, reason);
}
