import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences prefs;

  AuthInterceptor(this.prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Get token from shared preferences
    final token = prefs.getString('auth_token');
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      // Clear token
      prefs.remove('auth_token');
      // TODO: Navigate to login page
    }

    super.onError(err, handler);
  }
}
