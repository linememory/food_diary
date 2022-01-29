part of 'entry_form_cubit.dart';

abstract class EntryFormState extends Equatable {
  const EntryFormState();

  @override
  List<Object?> get props => [];
}

class EntryFormInvalid extends EntryFormState {}

class EntryFormValid extends EntryFormState {
  final DiaryEntry entry;
  const EntryFormValid({required this.entry}) : super();

  @override
  List<Object?> get props => super.props..add(entry);
}

class EntryFormSubmitted extends EntryFormState {}

class EntryFormSubmitFailed extends EntryFormState {
  final String message;

  const EntryFormSubmitFailed({required this.message});
}
