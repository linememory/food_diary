part of 'diary_bloc.dart';

abstract class DiaryEvent extends Equatable {
  const DiaryEvent();

  @override
  List<Object> get props => [];
}

class DiaryGetEntries extends DiaryEvent {}

class DiaryAddEntry extends DiaryEvent {
  final DiaryEntry entry;

  const DiaryAddEntry(this.entry);

  @override
  List<Object> get props => [entry];
}

class DiaryUpdateEntry extends DiaryEvent {
  final DiaryEntry entry;

  const DiaryUpdateEntry(this.entry);

  @override
  List<Object> get props => [entry];
}

class DiaryDeleteEntry extends DiaryEvent {
  final int id;

  const DiaryDeleteEntry(
    this.id,
  );

  @override
  List<Object> get props => [id];
}
