import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/judge_assignment.dart';

abstract class JudgeRepository {
  Future<Either<Failure, List<JudgeAssignment>>> getMyAssignments();
  Future<Either<Failure, JudgeAssignment>> getAssignmentDetail(int assignmentId);
  Future<Either<Failure, List<EvaluationCriteria>>> getEvaluationCriteria();
  Future<Either<Failure, Unit>> submitEvaluation(
    int assignmentId,
    Map<int, int> scores, // criteriaId -> score
  );
  Future<Either<Failure, JudgeStats>> getMyStats();
  Future<Either<Failure, List<JudgeAssignment>>> getMyHistory();
}
