import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/data/datasources/meal_datasource.dart';
import 'package:food_diary/features/diary/data/repositories/meal_repository_impl.dart';
import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';
import 'package:food_diary/features/diary/domain/usecases/add_meal.dart';
import 'package:food_diary/features/diary/domain/usecases/delete_meal.dart';
import 'package:food_diary/features/diary/domain/usecases/get_all_meals.dart';
import 'package:food_diary/features/diary/domain/usecases/update_meal.dart';
import 'package:get_it/get_it.dart';

import 'features/diary/presentation/bloc/diary_bloc.dart';

final sl = GetIt.instance;

void init() {
  //* Features - Diary
  sl.registerFactory(() => DiaryBloc(
      getAllMeals: sl(), addMeal: sl(), updateMeal: sl(), deleteMeal: sl()));
  sl.registerLazySingleton(() => GetAllMeals(sl()));
  sl.registerLazySingleton(() => AddMeal(sl()));
  sl.registerLazySingleton(() => UpdateMeal(sl()));
  sl.registerLazySingleton(() => DeleteMeal(sl()));
  sl.registerLazySingleton<MealRepository>(() => MealRepositoryImpl(sl()));
  sl.registerLazySingleton<MealDatasource>(() => MealDatasourceImpl(sl()));
 
  //* Core
  sl.registerLazySingleton(() => DatabaseHelper());

  //
}
