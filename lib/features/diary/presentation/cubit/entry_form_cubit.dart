import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';

part 'entry_form_state.dart';

class EntryFormCubit extends Cubit<EntryFormState> {
  EntryFormCubit(this.diaryFacadeService) : super(EntryFormInitial());

  DiaryFacadeService diaryFacadeService;

  void submit(DiaryEntry entry) async {
    bool success = await diaryFacadeService.addDiaryEntry(entry);
    success
        ? emit(EntryFormSubmitted())
        : emit(EntryFormSubmitFailed(
            message: "Failed to add entry:\n " + entry.toString()));
  }
}
