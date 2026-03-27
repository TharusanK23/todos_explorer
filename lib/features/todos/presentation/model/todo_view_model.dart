import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:todos_explorer/export/exports.dart';

class TodoViewModel extends BaseViewModel {
  TodoViewModel() : todoBloc = getIt<TodoBloc>();

  final TodoBloc todoBloc;

  List<TodoEntity> _todos = [];
  List<TodoEntity> get todos => _todos;

  List<TodoEntity> visibleTodos = [];

  int page = 1;
  final int limit = 10;

  FilterType filter = FilterType.all;
  SortType sort = SortType.asc;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  void onInit(BuildContext context) {
    todoBloc.add(GetAllTodoEvent());
  }

  void setAllTodos(List<TodoEntity> todos) {
    _todos = todos;
    applyAll();
    notifyListeners();
  }

  void applyAll() {
    List<TodoEntity> temp = [...todos];

    // Search
    if (searchQuery.isNotEmpty) {
      temp = temp.where((e) => e.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    // Filter
    if (filter == FilterType.completed) {
      temp = temp.where((e) => e.completed).toList();
    } else if (filter == FilterType.pending) {
      temp = temp.where((e) => !e.completed).toList();
    }

    // Sort
    temp.sort((a, b) => sort == SortType.asc ? a.title.compareTo(b.title) : b.title.compareTo(a.title));

    // Pagination
    final end = page * limit;
    visibleTodos = temp.take(end).toList();
  }

  void loadMore() {
    page++;
    applyAll();
    notifyListeners();
  }

  void changeFilter(FilterType newFilter) {
    filter = newFilter;
    page = 1;
    applyAll();
    notifyListeners();
  }

  void changeSort(SortType newSort) {
    sort = newSort;
    page = 1;
    applyAll();
    notifyListeners();
  }

  void onSearch(String value) {
    _searchQuery = value;
    page = 1; // reset pagination
    applyAll();
    notifyListeners();
  }

  Future<void> refreshData() async {
    todoBloc.add(GetAllTodoEvent());
  }
}
