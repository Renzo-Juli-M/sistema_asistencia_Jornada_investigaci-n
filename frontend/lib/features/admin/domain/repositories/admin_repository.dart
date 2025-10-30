import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_stats.dart';
import '../entities/article.dart';
import '../../data/models/article_model.dart';
import '../../data/models/category_model.dart';

abstract class AdminRepository {
  Future<Either<Failure, DashboardStats>> getDashboardStats();
  Future<Either<Failure, ArticleListResponse>> getArticles(Map<String, dynamic> params);
  Future<Either<Failure, ArticleModel>> createArticle(Map<String, dynamic> data);
  Future<Either<Failure, ArticleModel>> updateArticle(int id, Map<String, dynamic> data);
  Future<Either<Failure, Unit>> deleteArticle(int id);
  Future<Either<Failure, ArticleModel>> getArticle(int id);
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, List<Map<String, dynamic>>>> getStudents();
  Future<Either<Failure, List<Map<String, dynamic>>>> getAvailableJudges(int articleId);
  Future<Either<Failure, Unit>> assignJudges(int articleId, List<int> judgeIds);
  Future<Either<Failure, Unit>> importStudents(dynamic formData);
  Future<Either<Failure, Unit>> importJudges(dynamic formData);
  Future<Either<Failure, Unit>> importArticles(dynamic formData);
}
