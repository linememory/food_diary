import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/diary_entry.dart';
import 'package:food_diary/features/diary/domain/repositories/diary_entry_reposity.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/entry_fixtures.dart';

class MockDiaryEntryRepository extends Mock implements DiaryEntryRepository {}

void main() {
  late DiaryFacadeService diaryFacadeService;
  late MockDiaryEntryRepository diaryEntryRepository;

  setUpAll(() {
    diaryEntryRepository = MockDiaryEntryRepository();
    diaryFacadeService = DiaryFacadeService(diaryEntryRepository);
  });

  group('get all entries', () {
    test("should return a list with all entries", () async {
      List<DiaryEntry> entries = EntryFixture.getEntries(2);
      // arrange
      when(() => diaryEntryRepository.getAll())
          .thenAnswer((_) async => entries);
      // act
      final result = await diaryFacadeService.getAllDiaryEvents();
      // assert
      expect(result, entries);
      verify(() => diaryEntryRepository.getAll());
      verifyNoMoreInteractions(diaryEntryRepository);
    });

    test("should return an empty list", () async {
      // arrange
      when(() => diaryEntryRepository.getAll()).thenAnswer((_) async => []);
      // act
      final result = await diaryFacadeService.getAllDiaryEvents();
      // assert
      expect(result, []);
      verify(() => diaryEntryRepository.getAll());
      verifyNoMoreInteractions(diaryEntryRepository);
    });
  });

  group('add entry', () {
    test("should add the given entry and return true", () async {
      DiaryEntry meal = EntryFixture.getMealEntries(1).first;
      // arrange
      when(() => diaryEntryRepository.upsert(meal))
          .thenAnswer((_) async => true);
      // act
      final result = await diaryFacadeService.addDiaryEntry(meal);
      // assert
      expect(result, true);
      verify(() => diaryEntryRepository.upsert(meal));
      verifyNoMoreInteractions(diaryEntryRepository);
    });
  });

  group('update entry', () {
    test('should update the given entry and return true', () async {
      DiaryEntry meal = EntryFixture.getMealEntries(1).first;
      // arrange
      when(() => diaryEntryRepository.upsert(meal))
          .thenAnswer((_) async => true);
      // act
      final result = await diaryFacadeService.updateDiaryEntry(meal);
      // assert
      expect(result, true);
      verify(() => diaryEntryRepository.upsert(meal));
      verifyNoMoreInteractions(diaryEntryRepository);
    });

    test('should not update any entry and return false', () async {
      DiaryEntry meal = EntryFixture.getMealEntries(1).first;
      // arrange
      when(() => diaryEntryRepository.upsert(meal))
          .thenAnswer((_) async => false);
      // act
      final result = await diaryFacadeService.updateDiaryEntry(meal);
      // assert
      expect(result, false);
      verify(() => diaryEntryRepository.upsert(meal));
      verifyNoMoreInteractions(diaryEntryRepository);
    });
  });

  group('delete entry', () {
    test('should delete the given entry and return true', () async {
      DiaryEntry meal = EntryFixture.getMealEntries(1).first;
      // arrange
      when(() => diaryEntryRepository.delete(any()))
          .thenAnswer((_) async => true);
      // act
      final result = await diaryFacadeService.deleteDiaryEntry(meal.id!);
      // assert
      expect(result, true);
      verify(() => diaryEntryRepository.delete(any()));
      verifyNoMoreInteractions(diaryEntryRepository);
    });

    test('should not delete any entry and return false', () async {
      DiaryEntry meal = EntryFixture.getMealEntries(1).first;
      // arrange
      when(() => diaryEntryRepository.delete(meal.id!))
          .thenAnswer((_) async => false);
      // act
      final result = await diaryFacadeService.deleteDiaryEntry(meal.id!);
      // assert
      expect(result, false);
      verify(() => diaryEntryRepository.delete(meal.id!));
      verifyNoMoreInteractions(diaryEntryRepository);
    });
  });
}
