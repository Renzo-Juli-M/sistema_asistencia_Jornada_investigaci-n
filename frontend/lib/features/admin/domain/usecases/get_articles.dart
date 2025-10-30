import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/admin_repository.dart';

class GetArticles {
  final AdminRepository repository;

  GetArticles(this.repository);

  Future<Either<Failure, ArticleListResponse>> call(
    Map<String, dynamic> params,
  ) async {
    return await repository.getArticles(params);
  }
}
