import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/judge_assignment.dart';
import '../../domain/repositories/judge_repository.dart';
import '../datasources/judge_remote_datasource.dart';

@LazySingleton(as: JudgeRepository)
class JudgeRepositoryImpl implements JudgeRepository {
  final JudgeRemoteDataSource remoteDataSource;

  JudgeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<JudgeAssignment>>> getMyAssignments() async {
    try {
      final result = await remoteDataSource.getMyAssignments();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JudgeAssignment>> getAssignmentDetail(
      int assignmentId) async {
    try {
      final result = await remoteDataSource.getAssignmentDetail(assignmentId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EvaluationCriteria>>>
      getEvaluationCriteria() async {
    try {
      final result = await remoteDataSource.getEvaluationCriteria();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitEvaluation(
    int assignmentId,
    Map<int, int> scores,
  ) async {
    try {
      await remoteDataSource.submitEvaluation(assignmentId, scores);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JudgeStats>> getMyStats() async {
    try {
      final result = await remoteDataSource.getMyStats();
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JudgeAssignment>>> getMyHistory() async {
    try {
      final result = await remoteDataSource.getMyHistory();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
