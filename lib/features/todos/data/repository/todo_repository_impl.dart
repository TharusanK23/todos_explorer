import 'package:dartz/dartz.dart';
import 'package:todos_explorer/export/exports.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remote;

  TodoRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodos() async {
    // return await remote.fetchTodos();

    try {
      final result = await remote.fetchTodos();
      // List<TodoModel> todos = (result as List).map((e) => TodoModel.fromJson(e)).toList();
      return Right(result);
    } on InvalidCredentialsException {
      return Left(InvalidCredentialsFailure());
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
