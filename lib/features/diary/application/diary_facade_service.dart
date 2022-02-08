import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/repositories/diary_entry_reposity.dart';

class DiaryFacadeService {
  DiaryFacadeService(this.diaryEventRepository);
  final DiaryEntryRepository diaryEventRepository;

  Future<List<DiaryEntry>> getAllDiaryEvents() async {
    return await diaryEventRepository.getAll();
  }

  Future<List<DiaryEntry>> getAllDiaryEventsForMonth(DateTime month) async {
    return await diaryEventRepository.getAllForMonth(month);
  }

  Future<bool> addDiaryEntry(DiaryEntry entry) async {
    return await diaryEventRepository.upsert(entry);
  }

  Future<bool> updateDiaryEntry(DiaryEntry entry) async {
    return await diaryEventRepository.upsert(entry);
  }

  Future<bool> deleteDiaryEntry(int entryId) async {
    return await diaryEventRepository.delete(entryId);
  }

  void addOnChnaged(Function() onChange) {
    diaryEventRepository.addOnChange(onChange);
  }
}
