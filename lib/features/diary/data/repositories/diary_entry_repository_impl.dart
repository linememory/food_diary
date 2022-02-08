import 'package:food_diary/features/diary/data/datasources/bowel_movement_datasource.dart';
import 'package:food_diary/features/diary/data/datasources/entry_datasource.dart';
import 'package:food_diary/features/diary/data/datasources/food_datasource.dart';
import 'package:food_diary/features/diary/data/datasources/symptom_datasource.dart';
import 'package:food_diary/features/diary/data/models/bowel_movement_dto.dart';
import 'package:food_diary/features/diary/data/models/entry_dto.dart';
import 'package:food_diary/features/diary/data/models/food_dto.dart';
import 'package:food_diary/features/diary/data/models/symptom_dto.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/domain/repositories/diary_entry_reposity.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';

class DiaryEntryRepositoryImpl extends DiaryEntryRepository {
  EntryDatasource entryDatasource;
  FoodDatasource foodDatasource;
  SymptomDatasource symptomDatasource;
  BowelMovementDatasource bowelMovementDatasource;

  List<Function()> listeners = [];

  DiaryEntryRepositoryImpl({
    required this.entryDatasource,
    required this.foodDatasource,
    required this.symptomDatasource,
    required this.bowelMovementDatasource,
  });

  @override
  Future<List<DiaryEntry>> getAll() async {
    List<DiaryEntry> entries = [];
    final allEntries = await entryDatasource.getAll();
    for (var entry in allEntries) {
      DiaryEntry? diaryEntry = await constructEntry(entry);
      if (diaryEntry != null) entries.add(diaryEntry);
    }
    return entries;
  }

  @override
  Future<List<DiaryEntry>> getAllForMonth(DateTime month) async {
    List<DiaryEntry> entries = [];
    final allEntries = await entryDatasource.getAllForMonth(month);
    for (var entry in allEntries) {
      DiaryEntry? diaryEntry = await constructEntry(entry);
      if (diaryEntry != null) entries.add(diaryEntry);
    }
    return entries;
  }

  @override
  Future<bool> upsert(DiaryEntry entry) async {
    int id = await entryDatasource.upsert(EntryDTO.fromEntity(entry));
    if (entry is MealEntry) {
      foodDatasource.delete(id);
      for (var item in entry.foods) {
        await foodDatasource
            .insert(FoodDTO.fromEntity(entryId: id, food: item));
      }
    } else if (entry is SymptomEntry) {
      symptomDatasource.delete(id);
      for (var item in entry.symptoms) {
        await symptomDatasource
            .insert(SymptomDTO.fromEntity(entryId: id, symptom: item));
      }
    } else if (entry is BowelMovementEntry) {
      bowelMovementDatasource.delete(id);

      await bowelMovementDatasource.insert(BowelMovementDTO.fromEntity(
          entryId: id, bowelMovement: entry.bowelMovement));
    }
    bool result = id == 0 ? false : true;
    if (result) notifyListeners();
    return result;
  }

  @override
  Future<bool> delete(int id) async {
    bool result = (await entryDatasource.delete(id)) == 0 ? false : true;
    if (result) notifyListeners();
    return result;
  }

  void notifyListeners() {
    for (var listener in listeners) {
      listener();
    }
  }

  @override
  void addOnChange(Function() onChange) {
    listeners.add(onChange);
  }

  Future<DiaryEntry?> constructEntry(EntryDTO entryDTO) async {
    int id = entryDTO.id!;
    switch (entryDTO.type) {
      case EntryType.meal:
        List<Food> foods = (await foodDatasource.getForEntry(id))
            .map((e) => e.toEntity())
            .toList();

        return MealEntry(
            id: entryDTO.id, dateTime: entryDTO.dateTime, foods: foods);

      case EntryType.symptom:
        List<Symptom> symptoms = (await symptomDatasource.getAllForEntry(id))
            .map((e) => e.toEntity())
            .toList();

        return SymptomEntry(
            id: entryDTO.id, dateTime: entryDTO.dateTime, symptoms: symptoms);

      case EntryType.bowelMovement:
        BowelMovementDTO? bowelMovementDto =
            (await bowelMovementDatasource.getForEntry(id));
        if (bowelMovementDto != null) {
          return BowelMovementEntry(
              id: entryDTO.id,
              dateTime: entryDTO.dateTime,
              bowelMovement: bowelMovementDto.toEntity());
        } else {
          entryDatasource.delete(id);
        }
        break;
      default:
    }
  }
}
