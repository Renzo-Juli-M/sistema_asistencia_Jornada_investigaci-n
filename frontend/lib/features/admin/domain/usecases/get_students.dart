import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/admin_repository.dart';

class GetStudents {
  final AdminRepository repository;

  GetStudents(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() async {
    return await repository.getStudents();
  }
}
