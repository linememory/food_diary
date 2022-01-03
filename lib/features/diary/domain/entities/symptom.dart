import 'package:equatable/equatable.dart';

class Symptom extends Equatable {
  final DateTime dateTime;
  final List<String> symptom;

  const Symptom({
    required this.dateTime,
    required this.symptom,
  });

  @override
  List<Object?> get props => [dateTime, symptom];
}
