import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/article_model.dart';
import '../repositories/admin_repository.dart';

class CreateArticle {
  final AdminRepository repository;

  CreateArticle(this.repository);

  Future<Either<Failure, ArticleModel>> call(
    Map<String, dynamic> data,
  ) async {
    return await repository.createArticle(data);
  }
}
