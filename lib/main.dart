import 'package:flutter/material.dart';

void main() {
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
