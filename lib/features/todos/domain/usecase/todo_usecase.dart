import 'package:dartz/dartz.dart';
import 'package:todos_explorer/export/exports.dart';

class GetTodosUseCase implements UseCase<List<TodoEntity>, NoParams> {
  final TodoRepository repository;

  GetTodosUseCase({required this.repository});

  @override
  Future<Either<Failure, List<TodoEntity>>> call(NoParams params) async {
    return await repository.getTodos();
  }
}
