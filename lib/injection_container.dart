import 'package:http/http.dart' as http;
import 'package:todos_explorer/export/exports.dart';

final getIt = GetIt.instance;

Future init() async {
  getIt.registerLazySingleton(() => http.Client());

  getIt.registerLazySingleton(() => TodoBloc(getTodosUseCase: getIt()));

  getIt.registerLazySingleton(() => GetTodosUseCase(repository: getIt()));

  getIt.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(remote: getIt()));

  getIt.registerLazySingleton<TodoRemoteDataSource>(() => TodoRemoteDataSourceImpl(client: getIt()));
}
