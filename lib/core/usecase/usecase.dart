import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

// base contract for every use case in every feature's domain layer
// Type is the success return type, Params is the input
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// use for use cases that take no parameters, e.g. GetCartItems
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
