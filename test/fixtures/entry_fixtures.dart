import 'package:food_diary/features/diary/domain/entities/bowel_movement_entry.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:food_diary/features/diary/domain/value_objects/bowel_movement.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';
import 'package:food_diary/features/diary/domain/value_objects/symptom.dart';

class EntryFixture {
  static const List<Food> _foods = [
    Food(name: "Food 1", amount: Amount.small),
    Food(name: "Food 2", amount: Amount.medium),
    Food(name: "Food 3", amount: Amount.high),
  ];
  static const List<Symptom> _symptoms = [
    Symptom(name: "Symptom 1", intensity: Intensity.low),
    Symptom(name: "Symptom 1", intensity: Intensity.medium),
    Symptom(name: "Symptom 1", intensity: Intensity.high),
  ];
  static const BowelMovement _bowelMovement =
      BowelMovement(note: "Note", stoolType: StoolType.type1);
  static DateTime _currentDate = DateTime(2022, 1, 1, 8);
  static final List<MealEntry> _mealEntries = [];
  static final List<SymptomEntry> _symptomEntries = [];
  static final List<BowelMovementEntry> _bowelMovementEntries = [];

  static int _entryCount = 1;

  static MealEntry getMealEntry() => getMealEntries(1).first;
  static SymptomEntry getSymptomEntry() => getSymptomEntries(1).first;
  static BowelMovementEntry getBowelMovementEntry() =>
      getBowelMovementEntries(1).first;

  static List<MealEntry> getMealEntries(int amount) {
    while (_mealEntries.length < amount) {
      _currentDate = _currentDate.add(const Duration(days: 1));
      _mealEntries.add(MealEntry(
          id: _entryCount++,
          dateTime: _currentDate,
          foods: List<Food>.from(_foods)));
    }
    return _mealEntries.sublist(0, amount);
  }

  static List<SymptomEntry> getSymptomEntries(int amount) {
    while (_symptomEntries.length < amount) {
      _currentDate = _currentDate.add(const Duration(days: 1));
      _symptomEntries.add(SymptomEntry(
          id: _entryCount++,
          dateTime: _currentDate,
          symptoms: List<Symptom>.from(_symptoms)));
    }
    return _symptomEntries.sublist(0, amount);
  }

  static List<BowelMovementEntry> getBowelMovementEntries(int amount) {
    while (_bowelMovementEntries.length < amount) {
      _currentDate = _currentDate.add(const Duration(days: 1));
      _bowelMovementEntries.add(BowelMovementEntry(
          id: _entryCount++,
          dateTime: _currentDate,
          bowelMovement: BowelMovement.from(_bowelMovement)));
    }
    return _bowelMovementEntries.sublist(0, amount);
  }

  static List<DiaryEntry> getEntries(int amount) {
    List<DiaryEntry> mealEntries = getMealEntries(amount);
    List<DiaryEntry> symptomEntries = getSymptomEntries(amount);
    List<DiaryEntry> bowelMovementEntries = getBowelMovementEntries(amount);
    List<DiaryEntry> entries = [];

    return entries
      ..addAll(mealEntries)
      ..addAll(symptomEntries)
      ..addAll(bowelMovementEntries);
  }
}
