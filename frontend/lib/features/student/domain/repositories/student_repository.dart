import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/student_attendance.dart';

abstract class StudentRepository {
  // Ponente: Generate QR for article
  Future<Either<Failure, QRData>> generateAttendanceQR(int articleId);
  
  // Oyente: Scan QR and register attendance
  Future<Either<Failure, AttendanceConfirmation>> scanAndRegisterAttendance(String qrCode);
  
  // Get my attendance history
  Future<Either<Failure, List<StudentAttendance>>> getMyAttendanceHistory();
  
  // Get my statistics
  Future<Either<Failure, StudentStats>> getMyStats();
  
  // Check if I already generated QR for an article (ponente)
  Future<Either<Failure, QRData?>> getExistingQR(int articleId);
  
  // Get my articles as ponente
  Future<Either<Failure, List<Map<String, dynamic>>>> getMyArticles();
}
