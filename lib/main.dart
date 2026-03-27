import 'package:flutter/material.dart';
import 'package:todos_explorer/export/exports.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await dotenv.load(fileName: ".env");
  ErrorWidget.builder = (FlutterErrorDetails details) => _errorWidget(details);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(
        fontFamily: AppConstants.fontFamily,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      routerConfig: AppRouter().router,
    );
  }
}

Widget _errorWidget(FlutterErrorDetails details) {
  return Material(
    color: AppColors.error,
    child: Center(
      child: Text(
        details.exceptionAsString(),
        style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ),
  );
}
