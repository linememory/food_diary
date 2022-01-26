import 'package:food_diary/core/database/database_helper.dart';
import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/data/datasources/bowel_movement_datasource.dart';
import 'package:food_diary/features/diary/data/datasources/entry_datasource.dart';
import 'package:food_diary/features/diary/data/datasources/food_datasource.dart';
import 'package:food_diary/features/diary/data/datasources/symptom_datasource.dart';
import 'package:food_diary/features/diary/data/repositories/diary_entry_repository_impl.dart';
import 'package:food_diary/features/diary/domain/repositories/diary_entry_reposity.dart';
import 'package:get_it/get_it.dart';

import 'features/diary/presentation/bloc/diary_bloc.dart';

final sl = GetIt.instance;

void init() {
  //* Features - Diary
  sl.registerLazySingleton(() => DiaryFacadeService(sl()));
  sl.registerFactory(() => DiaryBloc(diaryFacadeService: sl()));

  sl.registerLazySingleton<DiaryEntryRepository>(() => DiaryEntryRepositoryImpl(
      entryDatasource: sl(),
      foodDatasource: sl(),
      symptomDatasource: sl(),
      bowelMovementDatasource: sl()));
  sl.registerLazySingleton<EntryDatasource>(() => EntryDatasourceImpl(sl()));
  sl.registerLazySingleton<FoodDatasource>(() => FoodDatasourceImpl(sl()));
  sl.registerLazySingleton<SymptomDatasource>(
      () => SymptomDatasourceImpl(sl()));
  sl.registerLazySingleton<BowelMovementDatasource>(
      () => BowelMovementDatasourceImpl(sl()));

  //* Core
  sl.registerLazySingleton(() => DatabaseHelper());

  //
}
