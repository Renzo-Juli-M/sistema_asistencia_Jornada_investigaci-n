import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/admin_repository.dart';

class GetArticleDetail {
  final AdminRepository repository;

  GetArticleDetail(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(int id) async {
    return await repository.getArticleDetail(id);
  }
}
