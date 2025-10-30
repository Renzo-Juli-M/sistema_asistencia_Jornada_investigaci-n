import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/admin_repository.dart';

class GetAvailableJudges {
  final AdminRepository repository;

  GetAvailableJudges(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call(int articleId) async {
    return await repository.getAvailableJudges(articleId);
  }
}
