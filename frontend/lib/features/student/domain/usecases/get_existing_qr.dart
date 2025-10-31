import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/student_attendance.dart';
import '../repositories/student_repository.dart';

@lazySingleton
class GetExistingQR {
  final StudentRepository repository;

  GetExistingQR(this.repository);

  Future<Either<Failure, QRData?>> call(int articleId) async {
    return await repository.getExistingQR(articleId);
  }
}
