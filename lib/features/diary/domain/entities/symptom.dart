import 'package:equatable/equatable.dart';

class Symptom extends Equatable {
  final int? id;
  final DateTime dateTime;
  final List<String> symptom;

  const Symptom({
    this.id,
    required this.dateTime,
    required this.symptom,
  });

  @override
  List<Object?> get props => [id, dateTime, symptom];
}
