import 'package:todos_explorer/export/exports.dart';

class TodoModel extends TodoEntity {
  TodoModel({required super.userId, required super.id, required super.title, required super.completed});

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(userId: json['userId'], id: json['id'], title: json['title'], completed: json['completed']);
  }
}
