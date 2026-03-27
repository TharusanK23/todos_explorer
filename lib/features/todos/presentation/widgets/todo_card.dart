import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:todos_explorer/export/exports.dart';

class TodoCard extends ViewModelWidget<TodoViewModel> {
  const TodoCard({super.key, required this.todo, required this.query}) : super(reactive: true);
  final TodoEntity todo;
  final String query;

  @override
  Widget build(BuildContext context, TodoViewModel model) {
    final isMatch = query.isEmpty ? false : todo.title.toLowerCase().contains(query.toLowerCase());

    return Card(
      color: isMatch ? AppColors.yellow : AppColors.backgroundLight,
      child: ListTile(
        leading: Icon(
          todo.completed ? Icons.check_circle : Icons.circle_outlined,
          color: todo.completed ? AppColors.secondary : AppColors.surfaceLight,
        ),
        title: Text(
          todo.title,
          style: TextStyle(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('ID: ${todo.id} • User: ${todo.userId}'),
        trailing: Text(
          todo.completed ? 'Completed' : 'Pending',
          style: TextStyle(color: todo.completed ? AppColors.secondary : AppColors.warning),
        ),
      ),
    );
  }
}
