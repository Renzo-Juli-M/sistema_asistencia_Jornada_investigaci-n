import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class ImportArticles {
  final AdminRepository repository;

  ImportArticles(this.repository);

  Future<Either<Failure, Unit>> call(dynamic formData) async {
    return await repository.importArticles(formData);
  }
}
