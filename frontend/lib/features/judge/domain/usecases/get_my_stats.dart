import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/judge_assignment.dart';
import '../repositories/judge_repository.dart';

@lazySingleton
class GetMyStats {
  final JudgeRepository repository;

  GetMyStats(this.repository);

  Future<Either<Failure, JudgeStats>> call() async {
    return await repository.getMyStats();
  }
}
