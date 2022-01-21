import 'package:equatable/equatable.dart';
import 'package:food_diary/features/diary/domain/value_objects/food.dart';

class Meal extends Equatable {
  final DateTime dateTime;
  final List<Food> foods;

  const Meal({
    required this.dateTime,
    required this.foods,
  });

  @override
  List<Object?> get props => [dateTime, foods];
}
