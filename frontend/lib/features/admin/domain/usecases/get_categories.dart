import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/category_model.dart';
import '../repositories/admin_repository.dart';

class GetCategories {
  final AdminRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<CategoryModel>>> call() async {
    return await repository.getCategories();
  }
}
