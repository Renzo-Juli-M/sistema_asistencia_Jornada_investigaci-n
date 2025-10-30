import 'package:dio/dio.dart';
import '../models/dashboard_stats_model.dart';
import '../models/article_model.dart';

abstract class AdminRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
  Future<ArticleListResponseModel> getArticles(Map<String, dynamic> params);
  Future<ArticleModel> createArticle(Map<String, dynamic> data);
  Future<ArticleModel> updateArticle(int id, Map<String, dynamic> data);
  Future<void> deleteArticle(int id);
  Future<ArticleModel> getArticle(int id);
  Future<List<CategoryModel>> getCategories();
  Future<List<Map<String, dynamic>>> getAvailableJudges(int articleId);
  Future<void> assignJudges(int articleId, List<int> judgeIds);
  Future<void> importStudents(FormData formData);
  Future<void> importJudges(FormData formData);
  Future<void> importArticles(FormData formData);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSourceImpl({required this.dio});

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final response = await dio.get('/api/admin/dashboard');
      return DashboardStatsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al obtener estadísticas');
    }
  }

  @override
  Future<ArticleListResponseModel> getArticles(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(
        '/api/admin/articles',
        queryParameters: params,
      );
      return ArticleListResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al obtener artículos');
    }
  }

  @override
  Future<ArticleModel> createArticle(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('/api/admin/articles', data: data);
      return ArticleModel.fromJson(response.data['article']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al crear artículo');
    }
  }

  @override
  Future<ArticleModel> updateArticle(int id, Map<String, dynamic> data) async {
    try {
      final response = await dio.put('/api/admin/articles/$id', data: data);
      return ArticleModel.fromJson(response.data['article']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al actualizar artículo');
    }
  }

  @override
  Future<void> deleteArticle(int id) async {
    try {
      await dio.delete('/api/admin/articles/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al eliminar artículo');
    }
  }

  @override
  Future<ArticleModel> getArticle(int id) async {
    try {
      final response = await dio.get('/api/admin/articles/$id');
      return ArticleModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al obtener artículo');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get('/api/admin/categories');
      return (response.data as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al obtener categorías');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableJudges(int articleId) async {
    try {
      final response = await dio.get('/api/admin/articles/$articleId/available-judges');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al obtener jurados');
    }
  }

  @override
  Future<void> assignJudges(int articleId, List<int> judgeIds) async {
    try {
      await dio.post('/api/admin/assignments/assign-multiple', data: {
        'article_id': articleId,
        'judge_ids': judgeIds,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al asignar jurados');
    }
  }

  @override
  Future<void> importStudents(FormData formData) async {
    try {
      await dio.post('/api/import/students', data: formData);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al importar estudiantes');
    }
  }

  @override
  Future<void> importJudges(FormData formData) async {
    try {
      await dio.post('/api/import/judges', data: formData);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al importar jurados');
    }
  }

  @override
  Future<void> importArticles(FormData formData) async {
    try {
      await dio.post('/api/import/articles', data: formData);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al importar artículos');
    }
  }
}
