import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/admin_repository.dart';

class ImportJudges {
  final AdminRepository repository;

  ImportJudges(this.repository);

  Future<Either<Failure, Unit>> call(dynamic formData) async {
    return await repository.importJudges(formData);
  }
}
