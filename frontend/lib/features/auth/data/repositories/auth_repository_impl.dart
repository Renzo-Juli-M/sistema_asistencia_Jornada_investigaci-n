import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> loginAdmin({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.loginAdmin(email, password);
      final token = result['token'] as String;
      final userModel = UserModel.fromJson(result['user']);

      await localDataSource.saveToken(token);
      await localDataSource.saveUser(userModel);

      return Right(userModel.toEntity());
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginStudent({
    required String dni,
    required String studentCode,
  }) async {
    try {
      final result = await remoteDataSource.loginStudent(dni, studentCode);
      final token = result['token'] as String;
      final userModel = UserModel.fromJson(result['user']);

      await localDataSource.saveToken(token);
      await localDataSource.saveUser(userModel);

      return Right(userModel.toEntity());
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginJudge({
    required String username,
    required String dni,
  }) async {
    try {
      final result = await remoteDataSource.loginJudge(username, dni);
      final token = result['token'] as String;
      final userModel = UserModel.fromJson(result['user']);

      await localDataSource.saveToken(token);
      await localDataSource.saveUser(userModel);

      return Right(userModel.toEntity());
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.deleteToken();
      await localDataSource.deleteUser();

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getUser();
      if (userModel != null) {
        return Right(userModel.toEntity());
      } else {
        return const Left(CacheFailure('Usuario no encontrado'));
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveToken(String token) async {
    try {
      await localDataSource.saveToken(token);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteToken() async {
    try {
      await localDataSource.deleteToken();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
