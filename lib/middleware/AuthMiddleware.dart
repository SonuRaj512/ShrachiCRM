import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrachi/api/routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? priority = 0;

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token") ?? '';

    final currentRoute = route.currentPage?.name;

    if (token.isNotEmpty &&
        !JwtDecoder.isExpired(token) &&
        currentRoute == AppRoutes.login) {
      return GetNavConfig.fromRoute(AppRoutes.Dasboard);
    }

    return null;
  }
}
