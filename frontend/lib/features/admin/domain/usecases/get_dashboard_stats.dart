import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_stats.dart';
import '../repositories/admin_repository.dart';

@lazySingleton
class GetDashboardStats {
  final AdminRepository repository;

  GetDashboardStats(this.repository);

  Future<Either<Failure, DashboardStats>> call() async {
    return await repository.getDashboardStats();
  }
}
