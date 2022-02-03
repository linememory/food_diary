import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/data/datasources/bowel_movement_datasource.dart';
import 'package:food_diary/features/diary/data/datasources/entry_datasource.dart';
import 'package:food_diary/features/diary/data/datasources/food_datasource.dart';
import 'package:food_diary/features/diary/data/datasources/symptom_datasource.dart';
import 'package:food_diary/features/diary/data/models/entry_dto.dart';
import 'package:food_diary/features/diary/data/models/symptom_dto.dart';
import 'package:food_diary/features/diary/data/repositories/diary_entry_repository_impl.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/entities/symptom_entry.dart';
import 'package:mocktail/mocktail.dart';

class MockEventDatasource extends Mock implements EntryDatasource {}

class MockFoodDatasource extends Mock implements FoodDatasource {}

class MockSymptomDatasource extends Mock implements SymptomDatasource {}

class MockBowelMovementDatasource extends Mock
    implements BowelMovementDatasource {}

void main() {
  late DiaryEntryRepositoryImpl eventRepository;
  late MockEventDatasource eventDatasource;
  late MockSymptomDatasource symptomDatasource;
  late MockFoodDatasource foodDatasource;
  late MockBowelMovementDatasource bowelMovementDatasource;

  setUp(() {
    eventDatasource = MockEventDatasource();
    symptomDatasource = MockSymptomDatasource();
    foodDatasource = MockFoodDatasource();
    bowelMovementDatasource = MockBowelMovementDatasource();
    eventRepository = DiaryEntryRepositoryImpl(
        entryDatasource: eventDatasource,
        foodDatasource: foodDatasource,
        symptomDatasource: symptomDatasource,
        bowelMovementDatasource: bowelMovementDatasource);
  });

  group('get all events', () {
    test('should return a list of all events', () async {
      // arrange
      DateTime dateTime = DateTime.now();
      EntryDTO eventDto =
          EntryDTO(id: 1, dateTime: dateTime, type: EntryType.symptom);
      SymptomDTO symptomDto = const SymptomDTO(
          id: 1, description: "Test", intensity: 0, entryId: 1);
      when(() => eventDatasource.getAll()).thenAnswer((_) async => [eventDto]);
      when(() => symptomDatasource.getAllForEntry(1))
          .thenAnswer((_) async => [symptomDto]);
      // act
      final List<DiaryEntry> result = await eventRepository.getAll();
      // assert
      verify(eventDatasource.getAll);
      expect(
          result,
          equals([
            SymptomEntry(
                id: 1,
                dateTime: eventDto.dateTime,
                symptoms: [symptomDto.toEntity()])
          ]));
    });

    test('should return an empty list', () async {
      // arrange
      when(() => eventDatasource.getAll()).thenAnswer((_) async => []);
      // act
      final List<DiaryEntry> result = await eventRepository.getAll();
      // assert
      verify(eventDatasource.getAll);
      expect(result.isEmpty, true);
    });
  });
}
