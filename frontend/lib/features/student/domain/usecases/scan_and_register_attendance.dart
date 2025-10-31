import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/student_attendance.dart';
import '../repositories/student_repository.dart';

@lazySingleton
class ScanAndRegisterAttendance {
  final StudentRepository repository;

  ScanAndRegisterAttendance(this.repository);

  Future<Either<Failure, AttendanceConfirmation>> call(String qrCode) async {
    return await repository.scanAndRegisterAttendance(qrCode);
  }
}
