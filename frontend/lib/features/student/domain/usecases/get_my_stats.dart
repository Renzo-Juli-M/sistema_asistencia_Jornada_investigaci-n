import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/student_attendance.dart';
import '../repositories/student_repository.dart';

@lazySingleton
class GetMyStats {
  final StudentRepository repository;

  GetMyStats(this.repository);

  Future<Either<Failure, StudentStats>> call() async {
    return await repository.getMyStats();
  }
}
