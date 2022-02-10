import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';

typedef VoidCallback = void Function();

abstract class DiaryEntryRepository {
  Future<List<DiaryEntry>> getAll();
  Future<List<DiaryEntry>> getAllForMonth(DateTime month);
  Future<bool> upsert(DiaryEntry entry);
  Future<bool> delete(int id);
  void addOnChangeListener(VoidCallback onChange);
  void removeOnChangeListener(VoidCallback onChange);
}
