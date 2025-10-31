import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/judge_assignment.dart';

part 'judge_assignment_model.g.dart';

@JsonSerializable()
class JudgeAssignmentModel {
  final int id;
  @JsonKey(name: 'article_id')
  final int articleId;
  @JsonKey(name: 'article')
  final ArticleInfo article;
  final String status;
  @JsonKey(name: 'assigned_at')
  final String assignedAt;
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @JsonKey(name: 'average_score')
  final double? averageScore;
  @JsonKey(name: 'has_evaluations')
  final bool hasEvaluations;

  JudgeAssignmentModel({
    required this.id,
    required this.articleId,
    required this.article,
    required this.status,
    required this.assignedAt,
    this.completedAt,
    this.averageScore,
    required this.hasEvaluations,
  });

  factory JudgeAssignmentModel.fromJson(Map<String, dynamic> json) =>
      _$JudgeAssignmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$JudgeAssignmentModelToJson(this);

  JudgeAssignment toEntity() {
    return JudgeAssignment(
      id: id,
      articleId: articleId,
      articleTitle: article.title,
      articleDescription: article.description ?? '',
      authorName: article.user?.name ?? 'Desconocido',
      categoryName: article.category?.name ?? 'Sin categoría',
      status: status,
      assignedAt: DateTime.parse(assignedAt),
      completedAt: completedAt != null ? DateTime.parse(completedAt!) : null,
      averageScore: averageScore,
      hasEvaluations: hasEvaluations,
    );
  }
}

@JsonSerializable()
class ArticleInfo {
  final int id;
  final String title;
  final String? description;
  final UserInfo? user;
  final CategoryInfo? category;

  ArticleInfo({
    required this.id,
    required this.title,
    this.description,
    this.user,
    this.category,
  });

  factory ArticleInfo.fromJson(Map<String, dynamic> json) =>
      _$ArticleInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleInfoToJson(this);
}

@JsonSerializable()
class UserInfo {
  final int id;
  final String name;

  UserInfo({required this.id, required this.name});

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable()
class CategoryInfo {
  final int id;
  final String name;

  CategoryInfo({required this.id, required this.name});

  factory CategoryInfo.fromJson(Map<String, dynamic> json) =>
      _$CategoryInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryInfoToJson(this);
}

@JsonSerializable()
class EvaluationCriteriaModel {
  final int id;
  final String name;
  final String? description;
  @JsonKey(name: 'max_score')
  final int maxScore;
  final int weight;

  EvaluationCriteriaModel({
    required this.id,
    required this.name,
    this.description,
    required this.maxScore,
    required this.weight,
  });

  factory EvaluationCriteriaModel.fromJson(Map<String, dynamic> json) =>
      _$EvaluationCriteriaModelFromJson(json);

  Map<String, dynamic> toJson() => _$EvaluationCriteriaModelToJson(this);

  EvaluationCriteria toEntity() {
    return EvaluationCriteria(
      id: id,
      name: name,
      description: description,
      maxScore: maxScore,
      weight: weight,
    );
  }
}

@JsonSerializable()
class JudgeStatsModel {
  @JsonKey(name: 'total_assignments')
  final int totalAssignments;
  @JsonKey(name: 'completed_evaluations')
  final int completedEvaluations;
  @JsonKey(name: 'pending_evaluations')
  final int pendingEvaluations;
  @JsonKey(name: 'average_score_given')
  final double averageScoreGiven;
  @JsonKey(name: 'recent_evaluations')
  final List<Map<String, dynamic>> recentEvaluations;

  JudgeStatsModel({
    required this.totalAssignments,
    required this.completedEvaluations,
    required this.pendingEvaluations,
    required this.averageScoreGiven,
    required this.recentEvaluations,
  });

  factory JudgeStatsModel.fromJson(Map<String, dynamic> json) =>
      _$JudgeStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$JudgeStatsModelToJson(this);

  JudgeStats toEntity() {
    return JudgeStats(
      totalAssignments: totalAssignments,
      completedEvaluations: completedEvaluations,
      pendingEvaluations: pendingEvaluations,
      averageScoreGiven: averageScoreGiven,
      recentEvaluations: recentEvaluations,
    );
  }
}
