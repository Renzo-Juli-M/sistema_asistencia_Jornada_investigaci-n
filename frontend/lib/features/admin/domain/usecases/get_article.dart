import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/article_model.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class GetArticle {
  final AdminRepository repository;

  GetArticle(this.repository);

  Future<Either<Failure, ArticleModel>> call(int id) async {
    return await repository.getArticle(id);
  }
}
