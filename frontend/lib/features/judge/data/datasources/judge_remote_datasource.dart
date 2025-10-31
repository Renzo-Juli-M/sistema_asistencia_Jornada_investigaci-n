import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/judge_assignment_model.dart';

abstract class JudgeRemoteDataSource {
  Future<List<JudgeAssignmentModel>> getMyAssignments();
  Future<JudgeAssignmentModel> getAssignmentDetail(int assignmentId);
  Future<List<EvaluationCriteriaModel>> getEvaluationCriteria();
  Future<void> submitEvaluation(int assignmentId, Map<int, int> scores);
  Future<JudgeStatsModel> getMyStats();
  Future<List<JudgeAssignmentModel>> getMyHistory();
}

@LazySingleton(as: JudgeRemoteDataSource)
class JudgeRemoteDataSourceImpl implements JudgeRemoteDataSource {
  final Dio dio;

  JudgeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<JudgeAssignmentModel>> getMyAssignments() async {
    try {
      final response = await dio.get('/api/judge/assignments');
      return (response.data as List)
          .map((json) => JudgeAssignmentModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al obtener asignaciones');
    }
  }

  @override
  Future<JudgeAssignmentModel> getAssignmentDetail(int assignmentId) async {
    try {
      final response = await dio.get('/api/judge/assignments/$assignmentId');
      return JudgeAssignmentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al obtener detalle');
    }
  }

  @override
  Future<List<EvaluationCriteriaModel>> getEvaluationCriteria() async {
    try {
      final response = await dio.get('/api/judge/criteria');
      return (response.data as List)
          .map((json) => EvaluationCriteriaModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al obtener criterios');
    }
  }

  @override
  Future<void> submitEvaluation(
      int assignmentId, Map<int, int> scores) async {
    try {
      // Convert Map<int, int> to List of evaluations
      final evaluations = scores.entries
          .map((entry) => {
                'criteria_id': entry.key,
                'score': entry.value,
              })
          .toList();

      await dio.post(
        '/api/judge/assignments/$assignmentId/evaluate',
        data: {'evaluations': evaluations},
      );
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al enviar evaluación');
    }
  }

  @override
  Future<JudgeStatsModel> getMyStats() async {
    try {
      final response = await dio.get('/api/judge/stats');
      return JudgeStatsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al obtener estadísticas');
    }
  }

  @override
  Future<List<JudgeAssignmentModel>> getMyHistory() async {
    try {
      final response = await dio.get('/api/judge/history');
      return (response.data as List)
          .map((json) => JudgeAssignmentModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al obtener historial');
    }
  }
}
