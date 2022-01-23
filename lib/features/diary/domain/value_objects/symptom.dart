import 'package:equatable/equatable.dart';

enum Intensity {
  low,
  medium,
  high,
}

extension ParseToString on Intensity {
  String get name => toString().split('.').last;
}

class Symptom extends Equatable {
  const Symptom({
    required this.name,
    required this.intensity,
  });

  Symptom.from(Symptom food)
      : name = food.name,
        intensity = food.intensity;

  final String name;
  final Intensity intensity;

  Symptom copyWith({
    String? name,
    Intensity? intensity,
  }) {
    return Symptom(
      name: name ?? this.name,
      intensity: intensity ?? this.intensity,
    );
  }

  @override
  List<Object?> get props => [name, intensity];
}
