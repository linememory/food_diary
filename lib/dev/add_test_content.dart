import 'dart:math';

import 'package:food_diary/features/diary/application/diary_facade_service.dart';
import 'package:food_diary/features/diary/domain/entities/meal.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';

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
    List<Food> foods = [];
    int foodCount = rng.nextInt(maxFoods - minFoods) + 3;
    for (var i = 0; i < foodCount; i++) {
      foods.add(Food(
          name: exampleFoods[rng.nextInt(exampleFoods.length)],
          amount: Amount.small));
    }
    DiaryFacadeService diaryFacadeService = sl();
    dateTime = dateTime.add(const Duration(hours: 6));
    await diaryFacadeService.addMeal(Meal(dateTime: dateTime, foods: foods));
  }
}

Future deleteTestContent() async {
  DiaryFacadeService diaryFacadeService = sl();
  List<Meal> result = await diaryFacadeService.getAllMeals();
  for (var i = 0; i < result.length; i++) {
    await diaryFacadeService.deleteMeal(result[i].dateTime);
  }
}
