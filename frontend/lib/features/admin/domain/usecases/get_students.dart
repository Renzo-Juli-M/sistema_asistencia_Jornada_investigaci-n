import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class GetStudents {
  final AdminRepository repository;

  GetStudents(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() async {
    return await repository.getStudents();
  }
}
