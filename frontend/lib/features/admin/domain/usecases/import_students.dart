import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class ImportStudents {
  final AdminRepository repository;

  ImportStudents(this.repository);

  Future<Either<Failure, Unit>> call(dynamic formData) async {
    return await repository.importStudents(formData);
  }
}
