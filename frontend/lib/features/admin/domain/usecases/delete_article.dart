import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class DeleteArticle {
  final AdminRepository repository;

  DeleteArticle(this.repository);

  Future<Either<Failure, Unit>> call(int articleId) async {
    return await repository.deleteArticle(articleId);
  }
}
