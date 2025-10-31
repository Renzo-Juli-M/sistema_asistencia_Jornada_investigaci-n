import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/student_repository.dart';

@lazySingleton
class GetMyArticles {
  final StudentRepository repository;

  GetMyArticles(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() async {
    return await repository.getMyArticles();
  }
}
