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

  DiaryEntryRepositoryImpl({
    required this.entryDatasource,
    required this.foodDatasource,
    required this.symptomDatasource,
    required this.bowelMovementDatasource,
  });

  @override
  Future<bool> delete(int id) async {
    return (await entryDatasource.delete(id)) == 0 ? false : true;
  }

  @override
  Future<List<DiaryEntry>> getAll() async {
    List<DiaryEntry> entries = [];
    final allEntries = await entryDatasource.getAll();
    for (var entry in allEntries) {
      int id = entry.id!;
      switch (entry.type) {
        case EntryType.meal:
          List<Food> foods = (await foodDatasource.getForEntry(id))
              .map((e) => e.toEntity())
              .toList();

          entries.add(
              MealEntry(id: entry.id, dateTime: entry.dateTime, foods: foods));
          break;
        case EntryType.symptom:
          List<Symptom> symptoms = (await symptomDatasource.getAllForEntry(id))
              .map((e) => e.toEntity())
              .toList();

          entries.add(SymptomEntry(
              id: entry.id, dateTime: entry.dateTime, symptoms: symptoms));
          break;

        case EntryType.bowelMovement:
          BowelMovementDTO? bowelMovementDto =
              (await bowelMovementDatasource.getForEntry(id));
          if (bowelMovementDto != null) {
            entries.add(BowelMovementEntry(
                id: entry.id,
                dateTime: entry.dateTime,
                bowelMovement: bowelMovementDto.toEntity()));
          } else {
            entryDatasource.delete(id);
          }
          break;
        default:
      }
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
    return id == 0 ? false : true;
  }
}
