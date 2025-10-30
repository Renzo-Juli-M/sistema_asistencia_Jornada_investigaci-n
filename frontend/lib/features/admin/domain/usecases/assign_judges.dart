import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/admin_repository.dart';

class AssignJudges {
  final AdminRepository repository;

  AssignJudges(this.repository);

  Future<Either<Failure, Unit>> call(int articleId, List<int> judgeIds) async {
    return await repository.assignJudges(articleId, judgeIds);
  }
}
