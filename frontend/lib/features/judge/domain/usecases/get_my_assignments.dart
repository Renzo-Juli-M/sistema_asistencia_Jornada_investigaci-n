import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/judge_assignment.dart';
import '../repositories/judge_repository.dart';

@lazySingleton
class GetMyAssignments {
  final JudgeRepository repository;

  GetMyAssignments(this.repository);

  Future<Either<Failure, List<JudgeAssignment>>> call() async {
    return await repository.getMyAssignments();
  }
}
