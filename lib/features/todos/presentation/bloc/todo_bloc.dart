import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_explorer/export/exports.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase getTodosUseCase;

  TodoBloc({required this.getTodosUseCase}) : super(TodoInitial()) {
    on<TodoEvent>((event, emit) {});
    on<GetAllTodoEvent>(_onGetAllTodo);
  }

  Future<void> _onGetAllTodo(GetAllTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final result = await getTodosUseCase(NoParams());

    result.fold(
      (failure) {
        if (failure is APIFailure) {
          emit(TodoError());
        } else {
          emit(TodoError());
        }
      },
      (todos) {
        emit(TodoLoaded(todos));
      },
    );
  }
}
