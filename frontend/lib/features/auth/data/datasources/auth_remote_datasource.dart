import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> loginAdmin(String email, String password);
  Future<Map<String, dynamic>> loginStudent(String dni, String studentCode);
  Future<Map<String, dynamic>> loginJudge(String username, String dni);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> loginAdmin(
      String email, String password) async {
    try {
      final response = await dio.post(
        '/api/login/admin',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error en el login');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error en el servidor');
    }
  }

  @override
  Future<Map<String, dynamic>> loginStudent(
      String dni, String studentCode) async {
    try {
      final response = await dio.post(
        '/api/login/student',
        data: {
          'dni': dni,
          'student_code': studentCode,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error en el login');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error en el servidor');
    }
  }

  @override
  Future<Map<String, dynamic>> loginJudge(String username, String dni) async {
    try {
      final response = await dio.post(
        '/api/login/judge',
        data: {
          'username': username,
          'dni': dni,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error en el login');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error en el servidor');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('/api/logout');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error en el servidor');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get('/api/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception('Error al obtener usuario');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error en el servidor');
    }
  }
}
