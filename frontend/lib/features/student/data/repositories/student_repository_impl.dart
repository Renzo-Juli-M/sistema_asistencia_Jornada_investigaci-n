import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/student_attendance.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_remote_datasource.dart';

@LazySingleton(as: StudentRepository)
class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;

  StudentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, QRData>> generateAttendanceQR(int articleId) async {
    try {
      final result = await remoteDataSource.generateAttendanceQR(articleId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceConfirmation>> scanAndRegisterAttendance(
      String qrCode) async {
    try {
      final result =
          await remoteDataSource.scanAndRegisterAttendance(qrCode);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StudentAttendance>>>
      getMyAttendanceHistory() async {
    try {
      final result = await remoteDataSource.getMyAttendanceHistory();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StudentStats>> getMyStats() async {
    try {
      final result = await remoteDataSource.getMyStats();
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, QRData?>> getExistingQR(int articleId) async {
    try {
      final result = await remoteDataSource.getExistingQR(articleId);
      return Right(result?.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getMyArticles() async {
    try {
      final result = await remoteDataSource.getMyArticles();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
