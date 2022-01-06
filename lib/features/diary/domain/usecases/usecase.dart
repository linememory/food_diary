import 'package:equatable/equatable.dart';

abstract class Usecase<Type, ParamType> {
  Future<Type> call(Param<ParamType> param);
}

class Param<Type> extends Equatable {
  final Type _param;
  const Param(
    this._param,
  );

  Type get get => _param;

  @override
  List<Object?> get props => [_param];

  static Param noParams() {
    return const Param({});
  }
}
