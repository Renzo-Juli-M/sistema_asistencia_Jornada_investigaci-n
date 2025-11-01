import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

@lazySingleton
class LoginJudge {
  final AuthRepository repository;

  LoginJudge(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String username,
    required String dni,
  }) async {
    return await repository.loginJudge(
      username: username,
      dni: dni,
    );
  }
}
