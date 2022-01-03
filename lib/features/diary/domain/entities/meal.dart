import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final DateTime dateTime;
  final List<String> foods;

  const Meal({
    required this.dateTime,
    required this.foods,
  });

  @override
  List<Object?> get props => [dateTime, foods];
}
