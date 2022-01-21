import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/data/datasources/meal_datasource.dart';
import 'package:food_diary/features/diary/data/repositories/meal_repository_impl.dart';
import 'package:food_diary/features/diary/domain/repositories/meal_repository.dart';
import 'package:food_diary/features/diary/presentation/bloc/meal_form_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/diary/presentation/bloc/diary_bloc.dart';

final sl = GetIt.instance;

void init() {
  //* Features - Diary
  sl.registerLazySingleton(() => DiaryFacadeService(sl()));
  sl.registerFactory(() => DiaryBloc(diaryFacadeService: sl()));

  sl.registerLazySingleton<MealRepository>(() => MealRepositoryImpl(sl()));
  sl.registerLazySingleton<MealDatasource>(() => MealDatasourceImpl(sl()));

  //sl.registerFactory(() => MealFormBloc(sl()));

  //* Core
  sl.registerLazySingleton(() => DatabaseHelper());

  //
}
