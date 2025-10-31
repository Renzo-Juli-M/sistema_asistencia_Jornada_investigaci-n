import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/article_model.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class UpdateArticle {
  final AdminRepository repository;

  UpdateArticle(this.repository);

  Future<Either<Failure, ArticleModel>> call(
    int articleId,
    Map<String, dynamic> data,
  ) async {
    return await repository.updateArticle(articleId, data);
  }
}
