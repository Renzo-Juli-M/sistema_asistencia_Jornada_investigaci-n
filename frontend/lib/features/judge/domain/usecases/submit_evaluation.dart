import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/judge_repository.dart';

@lazySingleton
class SubmitEvaluation {
  final JudgeRepository repository;

  SubmitEvaluation(this.repository);

  Future<Either<Failure, Unit>> call(
    int assignmentId,
    Map<int, int> scores,
  ) async {
    return await repository.submitEvaluation(assignmentId, scores);
  }
}
