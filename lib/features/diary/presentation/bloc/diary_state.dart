part of 'diary_bloc.dart';

abstract class DiaryState extends Equatable {
  final List<DiaryEntry> entries;
  const DiaryState(this.entries);

  @override
  List<Object> get props => [entries];

  @override
  String toString() => '$runtimeType (meals: ${entries.length})';
}

class DiaryLoadInProgress extends DiaryState {
  const DiaryLoadInProgress(List<DiaryEntry> entries) : super(entries);
}

class DiaryLoadSuccess extends DiaryState {
  const DiaryLoadSuccess(List<DiaryEntry> entries) : super(entries);
}

class DiaryEmpty extends DiaryState {
  final String message = "No meals tracked";

  const DiaryEmpty() : super(const []);

  @override
  List<Object> get props => [entries, message];
}

class DiaryFailure extends DiaryState {
  final String reason;

  const DiaryFailure(List<DiaryEntry> entries, this.reason) : super(entries);

  @override
  List<Object> get props => [entries, reason];
}

class DiaryAddFailure extends DiaryFailure {
  const DiaryAddFailure(List<DiaryEntry> entries, String reason)
      : super(entries, reason);
}

class DiaryUpdateFailure extends DiaryFailure {
  const DiaryUpdateFailure(List<DiaryEntry> entries, String reason)
      : super(entries, reason);
}

class DiaryDeleteFailure extends DiaryFailure {
  const DiaryDeleteFailure(List<DiaryEntry> entries, String reason)
      : super(entries, reason);
}
