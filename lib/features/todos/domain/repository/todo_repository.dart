import 'package:dartz/dartz.dart';
import 'package:todos_explorer/export/exports.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoEntity>>> getTodos();
}
