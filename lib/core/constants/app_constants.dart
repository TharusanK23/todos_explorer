import 'package:todos_explorer/export/exports.dart';

class AppConstants {
  static String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static const String appName = 'Todos Explores';
  static const String fontFamily = 'Poppins';
}
