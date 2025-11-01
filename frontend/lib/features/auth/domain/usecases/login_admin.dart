import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

@lazySingleton
class LoginAdmin {
  final AuthRepository repository;

  LoginAdmin(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.loginAdmin(
      email: email,
      password: password,
    );
  }
}
