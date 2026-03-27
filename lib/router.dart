import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:todos_explorer/export/exports.dart';

class AppRouter {
  AppRouter();

  GoRouter get router => GoRouter(
    initialLocation: '/',
    routes: [GoRoute(path: '/', builder: (context, state) => TodoListView())],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
