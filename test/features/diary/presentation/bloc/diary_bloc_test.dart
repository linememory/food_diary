import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:food_diary/features/diary/presentation/bloc/misc/meal_item.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/meal_fixtures.dart';

class MockDiaryFacadeService extends Mock implements DiaryFacadeService {}

void main() {
  late DiaryBloc bloc;
  late MockDiaryFacadeService mockDiaryFacadeService;

  setUp(() {
    registerFallbackValue(Meal(dateTime: DateTime(0), foods: const []));
    mockDiaryFacadeService = MockDiaryFacadeService();

    when(() => mockDiaryFacadeService.getAllMeals())
        .thenAnswer((_) async => []);
    when(() => mockDiaryFacadeService.addMeal(MealFixture.meal()))
        .thenAnswer((_) async => true);
    when(() => mockDiaryFacadeService.updateMeal(any()))
        .thenAnswer((_) async => true);
    when(() => mockDiaryFacadeService.deleteMeal(any()))
        .thenAnswer((_) async => true);
    bloc = DiaryBloc(diaryFacadeService: mockDiaryFacadeService);
  });
  group(('diary bloc'), () {
    blocTest<DiaryBloc, DiaryState>(
      'emits [Loading(), Empty())] at start.',
      build: () => DiaryBloc(diaryFacadeService: mockDiaryFacadeService),
      verify: (_) => verify(() => mockDiaryFacadeService.getAllMeals()),
      expect: () =>
          <DiaryState>[const DiaryLoadInProgress([]), const DiaryEmpty()],
    );

    group(('add meal to diary'), () {
      blocTest<DiaryBloc, DiaryState>(
        'emits [Loaded()] when AddMealToDiary is added.',
        build: () => bloc,
        act: (bloc) =>
            bloc.add(DiaryAddMeal(MealItem.fromMealEntity(MealFixture.meal()))),
        verify: (_) =>
            verify(() => mockDiaryFacadeService.addMeal(MealFixture.meal())),
        expect: () => <DiaryState>[
          DiaryLoadSuccess([MealItem.fromMealEntity(MealFixture.meal())])
        ],
      );

      blocTest<DiaryBloc, DiaryState>(
        'emits [MealNotAdded()] when AddMealToDiary is added and AddMeal usecase returns false.',
        build: () => bloc,
        setUp: () => when(() => mockDiaryFacadeService.addMeal(any()))
            .thenAnswer((invocation) async => false),
        act: (bloc) =>
            bloc.add(DiaryAddMeal(MealItem.fromMealEntity(MealFixture.meal()))),
        verify: (_) =>
            verify(() => mockDiaryFacadeService.addMeal(MealFixture.meal())),
        expect: () => <DiaryState>[
          const DiaryAddFailure([], "Meal could not be added"),
          const DiaryEmpty()
        ],
      );
    });

    group(('delete meal from diary'), () {
      blocTest<DiaryBloc, DiaryState>(
        'emits [Loaded())] when DeleteMealFromDiary is added.',
        build: () => bloc,
        skip: 1,
        act: (bloc) {
          bloc.add(DiaryAddMeal(MealItem.fromMealEntity(MealFixture.meal())));
          bloc.add(DiaryDeleteMeal(MealFixture.meal().id!));
        },
        verify: (_) => verify(
            () => mockDiaryFacadeService.deleteMeal(MealFixture.meal().id!)),
        expect: () => <DiaryState>[const DiaryEmpty()],
      );

      blocTest<DiaryBloc, DiaryState>(
        'emits [MealNotDeleted())] when DeleteMealFromDiary is added when meal is not in diary.',
        build: () => bloc,
        act: (bloc) {
          bloc.add(DiaryDeleteMeal(MealFixture.meal().id!));
        },
        verify: (_) =>
            verifyNever(() => mockDiaryFacadeService.deleteMeal(any())),
        expect: () => <DiaryState>[
          const DiaryDeleteFailure([], "No meal to delete"),
          const DiaryEmpty()
        ],
      );

      blocTest<DiaryBloc, DiaryState>(
        'emits [MealNotDeleted())] when DeleteMealFromDiary is added and DeleteMeal repository returns false.',
        build: () => bloc,
        setUp: () => when(() => mockDiaryFacadeService.deleteMeal(any()))
            .thenAnswer((invocation) async => false),
        skip: 1,
        act: (bloc) {
          bloc.add(DiaryAddMeal(MealItem.fromMealEntity(MealFixture.meal())));
          bloc.add(DiaryDeleteMeal(MealFixture.meal().id!));
        },
        verify: (_) => verify(
            () => mockDiaryFacadeService.deleteMeal(MealFixture.meal().id!)),
        expect: () => <DiaryState>[
          DiaryDeleteFailure([MealItem.fromMealEntity(MealFixture.meal())],
              "Meal could not be deleted"),
          DiaryLoadSuccess([MealItem.fromMealEntity(MealFixture.meal())])
        ],
      );
    });

    group(('update meal in diary'), () {
      late Meal mealToUpdate;

      blocTest<DiaryBloc, DiaryState>(
        'emits [Loaded()] when UpdateMealInDiary is added.',
        build: () => bloc,
        skip: 1,
        setUp: () {
          mealToUpdate = MealFixture.meal().copyWith();
          mealToUpdate.foods.removeAt(1);
        },
        act: (bloc) {
          bloc.add(DiaryAddMeal(MealItem.fromMealEntity(MealFixture.meal())));
          bloc.add(DiaryUpdateMeal(MealItem.fromMealEntity(mealToUpdate)));
        },
        verify: (_) =>
            verify(() => mockDiaryFacadeService.updateMeal(mealToUpdate)),
        expect: () => <DiaryState>[
          DiaryLoadSuccess([MealItem.fromMealEntity(mealToUpdate)])
        ],
      );

      blocTest<DiaryBloc, DiaryState>(
        'emits [] when UpdateMealInDiary is added while diary has no meals.',
        build: () => bloc,
        act: (bloc) {
          bloc.add(DiaryUpdateMeal(MealItem.fromMealEntity(mealToUpdate)));
        },
        verify: (_) =>
            verifyNever(() => mockDiaryFacadeService.updateMeal(any())),
        expect: () => <DiaryState>[
          const DiaryUpdateFailure([], "No meal to update"),
          const DiaryEmpty()
        ],
      );

      blocTest<DiaryBloc, DiaryState>(
        'emits [] when UpdateMealInDiary is added and UpdateMeal returns false.',
        build: () => bloc,
        skip: 1,
        setUp: () {
          when(() => mockDiaryFacadeService.updateMeal(any()))
              .thenAnswer((invocation) async => false);
        },
        act: (bloc) {
          bloc.add(DiaryAddMeal(MealItem.fromMealEntity(MealFixture.meal())));
          bloc.add(DiaryUpdateMeal(MealItem.fromMealEntity(mealToUpdate)));
        },
        verify: (_) =>
            verify(() => mockDiaryFacadeService.updateMeal(mealToUpdate)),
        expect: () => <DiaryState>[
          DiaryUpdateFailure([MealItem.fromMealEntity(MealFixture.meal())],
              "Meal could not be updated"),
          DiaryLoadSuccess([MealItem.fromMealEntity(MealFixture.meal())])
        ],
      );
    });
  });
}
