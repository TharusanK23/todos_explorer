import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todos_explorer/export/exports.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> fetchTodos();
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final http.Client client;

  TodoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TodoModel>> fetchTodos() async {
    final response = await client.get(
      Uri.parse(AppConstants.baseUrl),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => TodoModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
