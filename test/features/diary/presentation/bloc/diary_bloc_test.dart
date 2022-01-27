import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/meal_entry.dart';
import 'package:food_diary/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/entry_fixtures.dart';

class MockDiaryFacadeService extends Mock implements DiaryFacadeService {}

void main() {
  late DiaryBloc bloc;
  late MockDiaryFacadeService mockDiaryFacadeService;

  setUp(() {
    registerFallbackValue(MealEntry(dateTime: DateTime(0), foods: const []));
    mockDiaryFacadeService = MockDiaryFacadeService();

    when(() => mockDiaryFacadeService.getAllDiaryEvents())
        .thenAnswer((_) async => []);
    when(() =>
            mockDiaryFacadeService.addDiaryEntry(EntryFixture.getMealEntry()))
        .thenAnswer((_) async => true);
    when(() => mockDiaryFacadeService.updateDiaryEntry(any()))
        .thenAnswer((_) async => true);
    when(() => mockDiaryFacadeService.deleteDiaryEntry(any()))
        .thenAnswer((_) async => true);
    bloc = DiaryBloc(diaryFacadeService: mockDiaryFacadeService);
  });
  group(('diary bloc'), () {
    blocTest<DiaryBloc, DiaryState>(
      'emits [Loading(), Empty())] at start.',
      build: () => DiaryBloc(diaryFacadeService: mockDiaryFacadeService),
      verify: (_) => verify(() => mockDiaryFacadeService.getAllDiaryEvents()),
      expect: () =>
          <DiaryState>[const DiaryLoadInProgress([]), const DiaryEmpty()],
    );

    group(('delete meal from diary'), () {
      blocTest<DiaryBloc, DiaryState>(
        'emits [Loaded())] when DeleteMealFromDiary is added.',
        build: () => bloc,
        skip: 1,
        act: (bloc) {
          bloc.add(
              DiaryAddEntry(EntryFixture.getMealEntry()));
          bloc.add(DiaryDeleteEntry(EntryFixture.getMealEntry().id!));
        },
        verify: (_) => verify(() => mockDiaryFacadeService
            .deleteDiaryEntry(EntryFixture.getMealEntry().id!)),
        expect: () => <DiaryState>[const DiaryEmpty()],
      );

      blocTest<DiaryBloc, DiaryState>(
        'emits [MealNotDeleted())] when DeleteMealFromDiary is added when meal is not in diary.',
        build: () => bloc,
        act: (bloc) {
          bloc.add(DiaryDeleteEntry(EntryFixture.getMealEntry().id!));
        },
        verify: (_) =>
            verifyNever(() => mockDiaryFacadeService.deleteDiaryEntry(any())),
        expect: () => <DiaryState>[
          const DiaryDeleteFailure([], "No meal to delete"),
          const DiaryEmpty()
        ],
      );

      blocTest<DiaryBloc, DiaryState>(
        'emits [MealNotDeleted())] when DeleteMealFromDiary is added and DeleteMeal repository returns false.',
        build: () => bloc,
        setUp: () => when(() => mockDiaryFacadeService.deleteDiaryEntry(any()))
            .thenAnswer((invocation) async => false),
        skip: 1,
        act: (bloc) {
          bloc.add(
              DiaryAddEntry(EntryFixture.getMealEntry()));
          bloc.add(DiaryDeleteEntry(EntryFixture.getMealEntry().id!));
        },
        verify: (_) => verify(() => mockDiaryFacadeService
            .deleteDiaryEntry(EntryFixture.getMealEntry().id!)),
        expect: () => <DiaryState>[
          DiaryDeleteFailure([EntryFixture.getMealEntry()],
              "Meal could not be deleted"),
          DiaryLoadSuccess([EntryFixture.getMealEntry()])
        ],
      );
    });
  });
}
