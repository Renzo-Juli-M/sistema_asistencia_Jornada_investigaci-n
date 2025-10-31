import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/judge_assignment.dart';
import '../repositories/judge_repository.dart';

@lazySingleton
class GetEvaluationCriteria {
  final JudgeRepository repository;

  GetEvaluationCriteria(this.repository);

  Future<Either<Failure, List<EvaluationCriteria>>> call() async {
    return await repository.getEvaluationCriteria();
  }
}
