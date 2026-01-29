import 'package:get/get.dart';
import '../views/layouts/authenticated_layout.dart';
import '../views/screens/auth/login.dart';
import '../views/screens/splash.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String Dasboard = '/Dasboard';
  static const String tourplan = '/Tourplan';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => Splash()),
    GetPage(name: login, page: () => Login()),
    GetPage(name: Dasboard, page: () => AuthenticatedLayout()),
    GetPage(name: tourplan, page: () => AuthenticatedLayout(newIndex: 1)),
  ];
}
