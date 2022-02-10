import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/presentation/cubit/entry_form_cubit.dart';

import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/entry_fixtures.dart';

class MockDiaryFacadeService extends Mock implements DiaryFacadeService {}

void main() {
  late EntryFormCubit cubit;
  late MockDiaryFacadeService mockDiaryFacadeService;

  setUp(() {
    registerFallbackValue(EntryFixture.getMealEntry());
    mockDiaryFacadeService = MockDiaryFacadeService();
    when(() => mockDiaryFacadeService.addDiaryEntry(any()))
        .thenAnswer((_) async => true);
    cubit = EntryFormCubit(mockDiaryFacadeService);
  });
  group(('diary bloc'), () {
    group(('submit'), () {
      blocTest<EntryFormCubit, EntryFormState>(
        'emits [EntryFormSubmitted()] when submit is called with meal.',
        build: () => cubit,
        act: (cubit) {
          cubit.submit(EntryFixture.getMealEntry());
        },
        verify: (_) => verify(() =>
            mockDiaryFacadeService.addDiaryEntry(EntryFixture.getMealEntry())),
        expect: () => <EntryFormState>[EntryFormSubmitted()],
      );

      blocTest<EntryFormCubit, EntryFormState>(
        'emits [EntryFormSubmitted()] when submit is called with symptom.',
        build: () => cubit,
        act: (cubit) {
          cubit.submit(EntryFixture.getSymptomEntry());
        },
        verify: (_) => verify(() => mockDiaryFacadeService
            .addDiaryEntry(EntryFixture.getSymptomEntry())),
        expect: () => <EntryFormState>[EntryFormSubmitted()],
      );

      blocTest<EntryFormCubit, EntryFormState>(
        'emits [EntryFormSubmitted()] when submit is called with bowel movement.',
        build: () => cubit,
        act: (cubit) {
          cubit.submit(EntryFixture.getBowelMovementEntry());
        },
        verify: (_) => verify(() => mockDiaryFacadeService
            .addDiaryEntry(EntryFixture.getBowelMovementEntry())),
        expect: () => <EntryFormState>[EntryFormSubmitted()],
      );
      blocTest<EntryFormCubit, EntryFormState>(
        'emits [EntryFormSubmitFailed()] when submit is called but failed to add entry.',
        build: () => cubit,
        setUp: () => when(() => mockDiaryFacadeService.addDiaryEntry(any()))
            .thenAnswer((_) async => false),
        act: (cubit) {
          cubit.submit(EntryFixture.getMealEntry());
        },
        verify: (_) => verify(() =>
            mockDiaryFacadeService.addDiaryEntry(EntryFixture.getMealEntry())),
        expect: () => <EntryFormState>[
          EntryFormSubmitFailed(
              message: "Failed to add entry:\n " +
                  EntryFixture.getMealEntry().toString())
        ],
      );
      blocTest<EntryFormCubit, EntryFormState>(
        'emits [EntryFormValid()] when formValid is called.',
        build: () => cubit,
        act: (cubit) {
          cubit.formValid(EntryFixture.getMealEntry());
        },
        verify: (_) => verifyNever(() =>
            mockDiaryFacadeService.addDiaryEntry(EntryFixture.getMealEntry())),
        expect: () => <EntryFormState>[
          EntryFormValid(entry: EntryFixture.getMealEntry())
        ],
      );
      blocTest<EntryFormCubit, EntryFormState>(
        'emits [EntryFormInvalid()] when formNotValid is called.',
        build: () => cubit,
        act: (cubit) {
          cubit.formNotValid();
        },
        verify: (_) => verifyNever(() =>
            mockDiaryFacadeService.addDiaryEntry(EntryFixture.getMealEntry())),
        expect: () => <EntryFormState>[EntryFormInvalid()],
      );
    });
  });
}
