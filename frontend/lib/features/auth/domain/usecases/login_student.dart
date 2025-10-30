import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class LoginStudent {
  final AuthRepository repository;

  LoginStudent(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String dni,
    required String studentCode,
  }) async {
    return await repository.loginStudent(
      dni: dni,
      studentCode: studentCode,
    );
  }
}
