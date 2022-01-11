import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/features/diary/data/models/meal_model.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/usecases/add_meal.dart';
import 'package:food_diary/features/diary/domain/usecases/delete_meal.dart';
import 'package:food_diary/features/diary/domain/usecases/get_all_meals.dart';
import 'package:food_diary/features/diary/domain/usecases/update_meal.dart';
import 'package:food_diary/features/diary/domain/usecases/usecase.dart';
import 'package:food_diary/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/meal_fixtures.dart';

class MockGetAllMeals extends Mock implements GetAllMeals {}

class MockAddMeal extends Mock implements AddMeal {}

class MockUpdateMeal extends Mock implements UpdateMeal {}

class MockDeleteMeal extends Mock implements DeleteMeal {}

void main() {
  late DiaryBloc bloc;
  late MockGetAllMeals mockGetAllMeals;
  late MockAddMeal mockAddMeal;
  late MockUpdateMeal mockUpdateMeal;
  late MockDeleteMeal mockDeleteMeal;

  setUp(() {
    registerFallbackValue(Param.noParam());
    mockGetAllMeals = MockGetAllMeals();
    mockAddMeal = MockAddMeal();
    mockUpdateMeal = MockUpdateMeal();
    mockDeleteMeal = MockDeleteMeal();
    when(() => mockGetAllMeals(Param.noParam())).thenAnswer((_) async => []);
    when(() => mockAddMeal(Param(MealFixture.meal())))
        .thenAnswer((_) async => true);
    when(() => mockUpdateMeal(any())).thenAnswer((_) async => true);
    when(() => mockDeleteMeal(any())).thenAnswer((_) async => true);
    bloc = DiaryBloc(
        getAllMeals: mockGetAllMeals,
        addMeal: mockAddMeal,
        updateMeal: mockUpdateMeal,
        deleteMeal: mockDeleteMeal);
  });
  group(('diary bloc'), () {
    blocTest<DiaryBloc, DiaryState>(
      'emits [Loading(), Empty())] at start.',
      build: () => DiaryBloc(
          getAllMeals: mockGetAllMeals,
          addMeal: mockAddMeal,
          updateMeal: mockUpdateMeal,
          deleteMeal: mockDeleteMeal),
      verify: (_) => verify(() => mockGetAllMeals(Param.noParam())),
      expect: () =>
          <DiaryState>[const DiaryLoadInProgress([]), const DiaryEmpty()],
    );

    group(('add meal to diary'), () {
      blocTest<DiaryBloc, DiaryState>(
        'emits [Loaded()] when AddMealToDiary is added.',
        build: () => bloc,
        act: (bloc) => bloc.add(DiaryAddMeal(MealFixture.meal())),
        verify: (_) => verify(() => mockAddMeal(Param(MealFixture.meal()))),
        expect: () => <DiaryState>[
          DiaryLoadSuccess([MealFixture.meal()])
        ],
      );

      blocTest<DiaryBloc, DiaryState>(
        'emits [MealNotAdded()] when AddMealToDiary is added and AddMeal usecase returns false.',
        build: () => bloc,
        setUp: () => when(() => mockAddMeal(any()))
            .thenAnswer((invocation) async => false),
        act: (bloc) => bloc.add(DiaryAddMeal(MealFixture.meal())),
        verify: (_) => verify(() => mockAddMeal(Param(MealFixture.meal()))),
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
          bloc.add(DiaryAddMeal(MealFixture.meal()));
          bloc.add(DiaryDeleteMeal(
              MealFixture.meal().dateTime.microsecondsSinceEpoch));
        },
        verify: (_) => verify(() => mockDeleteMeal(Param(
            Meal(dateTime: MealFixture.meal().dateTime, foods: const [])))),
        expect: () => <DiaryState>[const DiaryLoadSuccess([])],
      );

      blocTest<DiaryBloc, DiaryState>(
        'emits [MealNotDeleted())] when DeleteMealFromDiary is added when meal is not in diary.',
        build: () => bloc,
        act: (bloc) {
          bloc.add(DiaryDeleteMeal(
              MealFixture.meal().dateTime.microsecondsSinceEpoch));
        },
        verify: (_) => verifyNever(() => mockDeleteMeal(any())),
        expect: () => <DiaryState>[
          const DiaryDeleteFailure([], "No meal to delete"),
          const DiaryEmpty()
        ],
      );

      blocTest<DiaryBloc, DiaryState>(
        'emits [MealNotDeleted())] when DeleteMealFromDiary is added and DeleteMeal repository returns false.',
        build: () => bloc,
        setUp: () => when(() => mockDeleteMeal(any()))
            .thenAnswer((invocation) async => false),
        skip: 1,
        act: (bloc) {
          bloc.add(DiaryAddMeal(MealFixture.meal()));
          bloc.add(DiaryDeleteMeal(
              MealFixture.meal().dateTime.microsecondsSinceEpoch));
        },
        verify: (_) => verify(() => mockDeleteMeal(Param(
            Meal(dateTime: MealFixture.meal().dateTime, foods: const [])))),
        expect: () => <DiaryState>[
          DiaryDeleteFailure([MealFixture.meal()], "Meal could not be deleted"),
          DiaryLoadSuccess([MealFixture.meal()])
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
          mealToUpdate = MealModel.from(MealFixture.meal());
          mealToUpdate.foods.removeAt(1);
        },
        act: (bloc) {
          bloc.add(DiaryAddMeal(MealFixture.meal()));
          bloc.add(DiaryUpdateMeal(mealToUpdate));
        },
        verify: (_) => verify(() => mockUpdateMeal(Param(mealToUpdate))),
        expect: () => <DiaryState>[
          DiaryLoadSuccess([mealToUpdate])
        ],
      );

      blocTest<DiaryBloc, DiaryState>(
        'emits [] when UpdateMealInDiary is added while diary has no meals.',
        build: () => bloc,
        act: (bloc) {
          bloc.add(DiaryUpdateMeal(mealToUpdate));
        },
        verify: (_) => verifyNever(() => mockUpdateMeal(any())),
        expect: () => <DiaryState>[
          const DiaryUpdateFailure([], "No meal to update"),
          const DiaryEmpty()
        ],
      );

      blocTest<DiaryBloc, DiaryState>(
        'emits [] when UpdateMealInDiary is added and UpdateMeal usecase returns false.',
        build: () => bloc,
        skip: 1,
        setUp: () {
          when(() => mockUpdateMeal(any()))
              .thenAnswer((invocation) async => false);
        },
        act: (bloc) {
          bloc.add(DiaryAddMeal(MealFixture.meal()));
          bloc.add(DiaryUpdateMeal(mealToUpdate));
        },
        verify: (_) => verify(() => mockUpdateMeal(Param(mealToUpdate))),
        expect: () => <DiaryState>[
          DiaryUpdateFailure([MealFixture.meal()], "Meal could not be updated"),
          DiaryLoadSuccess([MealFixture.meal()])
        ],
      );
    });
  });
}
