import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginAdmin({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> loginStudent({
    required String dni,
    required String studentCode,
  });

  Future<Either<Failure, UserEntity>> loginJudge({
    required String username,
    required String dni,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, String?>> getToken();

  Future<Either<Failure, Unit>> saveToken(String token);

  Future<Either<Failure, Unit>> deleteToken();
}
