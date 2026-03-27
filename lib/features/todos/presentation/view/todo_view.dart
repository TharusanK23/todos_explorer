import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:todos_explorer/export/exports.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TodoViewModel>.reactive(
      viewModelBuilder: () => TodoViewModel(),
      onViewModelReady: (vm) => vm.onInit(context),
      builder: (context, vm, child) {
        return TodoContent();
      },
    );
  }
}

class TodoContent extends ViewModelWidget<TodoViewModel> {
  const TodoContent({super.key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, TodoViewModel model) {
    return BlocProvider(
      create: (context) => model.todoBloc,
      child: BlocConsumer<TodoBloc, TodoState>(
        bloc: model.todoBloc,
        listener: (context, state) {
          if (state is TodoLoaded) {
            model.setAllTodos(state.todos);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Todos Explorer', style: TextStyle(fontSize: 18.0)),
                actions: [
                  PopupMenuButton<SortType>(
                    onSelected: model.changeSort,
                    icon: Icon(Icons.filter_alt_outlined),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: SortType.asc, child: Text("Sort A-Z")),
                      const PopupMenuItem(value: SortType.desc, child: Text("Sort Z-A")),
                    ],
                  ),
                ],
                backgroundColor: AppColors.surfaceLight,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search todos...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (value) => model.onSearch(value),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      filterBtn("All", FilterType.all, model),
                      filterBtn("Completed", FilterType.completed, model),
                      filterBtn("Pending", FilterType.pending, model),
                    ],
                  ),

                  const SizedBox(height: 10),
                  state is TodoLoading
                      ? CircularProgressIndicator()
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: model.refreshData,
                            backgroundColor: AppColors.primary,
                            color: AppColors.backgroundLight,
                            child: TodoList(),
                          ),
                        ),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 1,
                color: AppColors.surfaceLight,
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  color: AppColors.surfaceLight,
                  child: Text('Showing ${model.visibleTodos.length} of ${model.todos.length}'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget filterBtn(String text, FilterType type, TodoViewModel model) {
    return InkWell(
      onTap: () => model.changeFilter(type),
      child: Container(
        width: 110,
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: model.filter == type ? AppColors.primary : AppColors.backgroundLight,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: TextStyle(color: model.filter == type ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          ],
        ),
      ),
    );
  }
}
