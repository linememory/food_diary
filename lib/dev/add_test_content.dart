import 'package:faker/faker.dart' as fk;

import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';

import '../injection_container.dart';

Future addTestContent({
  int mealsCount = 10,
  int symptomsCount = 0,
  int bowelMovementCount = 0,
  int? seed,
}) async {
  fk.Faker faker = fk.Faker(seed: seed);
  await _addMeals(mealsCount, faker);
  await _addSymptoms(symptomsCount, faker);
  await _addBowelMovements(bowelMovementCount, faker);
}

Future deleteTestContent() async {
  DiaryFacadeService diaryFacadeService = sl();
  List<DiaryEntry> result = await diaryFacadeService.getAllDiaryEvents();
  for (var i = 0; i < result.length; i++) {
    await diaryFacadeService.deleteDiaryEntry(result[i].id!);
  }
}

_addMeals(int count, fk.Faker faker) async {
  int min = 3;
  int max = 10;
  DateTime dateTime = DateTime.now();
  for (var i = 0; i < count; i++) {
    List<Food> foods = [];
    int foodCount = faker.randomGenerator.integer(max - min) + 3;
    for (var i = 0; i < foodCount; i++) {
      String food = fk.faker.food.dish();
      foods.add(Food(
          name: food, amount: Amount.values[faker.randomGenerator.integer(3)]));
    }
    DiaryFacadeService diaryFacadeService = sl();
    dateTime = dateTime.add(const Duration(hours: 6));
    await diaryFacadeService
        .addDiaryEntry(MealEntry(dateTime: dateTime, foods: foods));
  }
}

_addSymptoms(int count, fk.Faker faker) async {
  final exampleFoods = [
    "Bloating",
    "Diarreha",
    "Nausea",
    "Brain Fog",
    "Pain",
    "Constipation",
    "Vomiting",
    "Sleepiness",
    "Headache",
    "Fever",
    "Sore Throat",
    "Cough",
    "Runny Nose",
    "Muscle Aches",
    "Fatigue",
    "Chills",
    "Shortness Of Breath",
    "Loss Of Taste",
  ];
  int min = 1;
  int max = 10;
  DateTime dateTime = DateTime.now();
  for (var i = 0; i < count; i++) {
    List<Symptom> symptoms = [];
    int foodCount = faker.randomGenerator.integer(max - min) + 3;
    for (var i = 0; i < foodCount; i++) {
      symptoms.add(Symptom(
          name:
              exampleFoods[faker.randomGenerator.integer(exampleFoods.length)],
          intensity: Intensity.values[faker.randomGenerator.integer(3)]));
    }
    DiaryFacadeService diaryFacadeService = sl();
    dateTime = dateTime.add(const Duration(hours: 6));
    await diaryFacadeService
        .addDiaryEntry(SymptomEntry(dateTime: dateTime, symptoms: symptoms));
  }
}

_addBowelMovements(int count, fk.Faker faker) async {
  int max = 10;
  DateTime dateTime = DateTime.now();
  for (var i = 0; i < count; i++) {
    String note =
        fk.faker.lorem.words(faker.randomGenerator.integer(max)).join(' ');
    BowelMovement bowelMovement = BowelMovement(
        stoolType: StoolType
            .values[faker.randomGenerator.integer(StoolType.values.length)],
        note: note);

    DiaryFacadeService diaryFacadeService = sl();
    dateTime = dateTime.add(const Duration(hours: 6));
    await diaryFacadeService.addDiaryEntry(
        BowelMovementEntry(dateTime: dateTime, bowelMovement: bowelMovement));
  }
}
