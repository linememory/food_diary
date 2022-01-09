import 'package:flutter/material.dart';
import 'package:food_diary/injection_container.dart';

void main() {
  init();
  runApp(const FoodDiary());
}

class FoodDiary extends StatelessWidget {
  const FoodDiary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Diary',
      home: Container(),
    );
  }
}
