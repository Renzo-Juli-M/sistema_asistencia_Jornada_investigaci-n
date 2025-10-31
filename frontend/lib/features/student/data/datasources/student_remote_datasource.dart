import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/student_attendance_model.dart';

abstract class StudentRemoteDataSource {
  Future<QRDataModel> generateAttendanceQR(int articleId);
  Future<AttendanceConfirmationModel> scanAndRegisterAttendance(String qrCode);
  Future<List<StudentAttendanceModel>> getMyAttendanceHistory();
  Future<StudentStatsModel> getMyStats();
  Future<QRDataModel?> getExistingQR(int articleId);
  Future<List<Map<String, dynamic>>> getMyArticles();
}

@LazySingleton(as: StudentRemoteDataSource)
class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final Dio dio;

  StudentRemoteDataSourceImpl(this.dio);

  @override
  Future<QRDataModel> generateAttendanceQR(int articleId) async {
    final response = await dio.post(
      '/api/student/articles/$articleId/generate-qr',
    );
    return QRDataModel.fromJson(response.data);
  }

  @override
  Future<AttendanceConfirmationModel> scanAndRegisterAttendance(
      String qrCode) async {
    final response = await dio.post(
      '/api/student/attendance/scan',
      data: {'qr_code': qrCode},
    );
    return AttendanceConfirmationModel.fromJson(response.data);
  }

  @override
  Future<List<StudentAttendanceModel>> getMyAttendanceHistory() async {
    final response = await dio.get('/api/student/attendance/history');
    return (response.data as List)
        .map((json) => StudentAttendanceModel.fromJson(json))
        .toList();
  }

  @override
  Future<StudentStatsModel> getMyStats() async {
    final response = await dio.get('/api/student/stats');
    return StudentStatsModel.fromJson(response.data);
  }

  @override
  Future<QRDataModel?> getExistingQR(int articleId) async {
    try {
      final response = await dio.get(
        '/api/student/articles/$articleId/qr',
      );
      if (response.data == null) return null;
      return QRDataModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMyArticles() async {
    final response = await dio.get('/api/student/my-articles');
    return List<Map<String, dynamic>>.from(response.data);
  }
}
