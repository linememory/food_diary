import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';

abstract class DiaryEntryRepository {
  Future<List<DiaryEntry>> getAll();
  Future<bool> upsert(DiaryEntry entry);
  Future<bool> delete(int id);
  void addOnChange(Function() onChange);
}
