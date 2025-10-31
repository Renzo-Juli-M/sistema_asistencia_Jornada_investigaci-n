import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/student_attendance.dart';
import '../repositories/student_repository.dart';

@lazySingleton
class GetMyAttendanceHistory {
  final StudentRepository repository;

  GetMyAttendanceHistory(this.repository);

  Future<Either<Failure, List<StudentAttendance>>> call() async {
    return await repository.getMyAttendanceHistory();
  }
}
