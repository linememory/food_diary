import 'dart:math';

import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/usecases/add_meal.dart';
import 'package:food_diary/features/diary/domain/usecases/delete_meal.dart';
import 'package:food_diary/features/diary/domain/usecases/get_all_meals.dart';
import 'package:food_diary/features/diary/domain/usecases/usecase.dart';

import '../injection_container.dart';

Future addTestContent({int mealsCount = 10, int? seed}) async {
  final exampleFoods = [
    "Flour",
    "Beans",
    "Onion",
    "Lentils",
    "Pasta",
    "Potato",
    "Carrot",
    "Corn",
    "Oats",
    "Beef",
    "Tuna",
    "Eg",
    "Tomato",
    "Bellpepper",
    "Sugar",
    "Mozarella",
    "Olives",
    "Oil",
  ];
  Random rng = Random(seed);
  int minFoods = 3;
  int maxFoods = 10;
  DateTime dateTime = DateTime.now();
  for (var i = 0; i < mealsCount; i++) {
    List<String> foods = [];
    int foodCount = rng.nextInt(maxFoods - minFoods) + 3;
    for (var i = 0; i < foodCount; i++) {
      foods.add(exampleFoods[rng.nextInt(exampleFoods.length)]);
    }
    AddMeal addMeal = sl();
    dateTime = dateTime.add(const Duration(hours: 6));
    await addMeal(Param(Meal(dateTime: dateTime, foods: foods)));
  }
}

Future deleteTestContent() async {
  GetAllMeals getAllMeals = sl();
  DeleteMeal deleteMeal = sl();
  List<Meal> result = await getAllMeals(Param.noParam());
  for (var i = 0; i < result.length; i++) {
    await deleteMeal(Param(result[i].dateTime));
  }
}
