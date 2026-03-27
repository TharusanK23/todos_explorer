import 'package:dartz/dartz.dart';
import 'package:todos_explorer/export/exports.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
