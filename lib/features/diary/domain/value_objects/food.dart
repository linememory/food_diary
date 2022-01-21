import 'package:equatable/equatable.dart';

enum Amount {
  small,
  medium,
  high,
}

extension ParseToString on Amount {
  String get name => toString().split('.').last;
}

class Food extends Equatable {
  const Food({
    required this.name,
    required this.amount,
  });

  final String name;
  final Amount amount;

  @override
  List<Object?> get props => [name, amount];
}
