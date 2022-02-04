import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/generated/l10n.dart';


part 'entry_form_state.dart';

class EntryFormCubit extends Cubit<EntryFormState> {
  EntryFormCubit(this.diaryFacadeService) : super(EntryFormInvalid());

  DiaryFacadeService diaryFacadeService;
  AppLocalization? localization;

  void submit(DiaryEntry entry) async {
    bool success = await diaryFacadeService.addDiaryEntry(entry);
    success
        ? emit(EntryFormSubmitted())
        : emit(EntryFormSubmitFailed(
            message: AppLocalization.current.entryFormSubmitFailed +
                entry.toString()));
  }

  void formValid(DiaryEntry entry) {
    emit(EntryFormValid(entry: entry));
  }

  void formNotValid() {
    emit(EntryFormInvalid());
  }
}


