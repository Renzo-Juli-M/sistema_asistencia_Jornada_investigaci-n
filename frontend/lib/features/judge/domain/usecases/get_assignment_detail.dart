import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/judge_assignment.dart';
import '../repositories/judge_repository.dart';

@lazySingleton
class GetAssignmentDetail {
  final JudgeRepository repository;

  GetAssignmentDetail(this.repository);

  Future<Either<Failure, JudgeAssignment>> call(int assignmentId) async {
    return await repository.getAssignmentDetail(assignmentId);
  }
}
