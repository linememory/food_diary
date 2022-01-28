part of 'entry_form_cubit.dart';

abstract class EntryFormState extends Equatable {
  const EntryFormState({this.entry});

  final DiaryEntry? entry;

  @override
  List<Object?> get props => [entry];
}

class EntryFormInitial extends EntryFormState {}

class EntryFormValid extends EntryFormState {
  const EntryFormValid({required DiaryEntry entry}) : super(entry: entry);
}

class EntryFormSubmitted extends EntryFormState {}

class EntryFormSubmitFailed extends EntryFormState {
  final String message;

  const EntryFormSubmitFailed({required this.message});
}
