import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:todos_explorer/export/exports.dart';

class TodoList extends ViewModelWidget<TodoViewModel> {
  const TodoList({super.key}) : super(reactive: true);

  @override
  Widget build(BuildContext context, TodoViewModel model) {
    return ListView.builder(
      itemCount: model.visibleTodos.length + 1,
      itemBuilder: (context, index) {
        if (index == model.visibleTodos.length) {
          return InkWell(
            onTap: model.loadMore,
            child: Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: AppColors.primary),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Load More', style: TextStyle(color: AppColors.surfaceLight))],
              ),
            ),
          );
        }

        final todo = model.visibleTodos[index];

        return TodoCard(todo: todo, query: model.searchQuery);
      },
    );
  }
}
