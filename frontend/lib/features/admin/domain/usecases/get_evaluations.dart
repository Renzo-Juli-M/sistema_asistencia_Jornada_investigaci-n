import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class GetEvaluations {
  final AdminRepository repository;

  GetEvaluations(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(Map<String, dynamic> params) async {
    return await repository.getEvaluations(params);
  }
}
