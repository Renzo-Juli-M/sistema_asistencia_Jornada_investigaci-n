import 'package:equatable/equatable.dart';

class JudgeAssignment extends Equatable {
  final int id;
  final int articleId;
  final String articleTitle;
  final String articleDescription;
  final String authorName;
  final String categoryName;
  final String status; // pending, in_progress, completed
  final DateTime assignedAt;
  final DateTime? completedAt;
  final double? averageScore;
  final bool hasEvaluations;

  const JudgeAssignment({
    required this.id,
    required this.articleId,
    required this.articleTitle,
    required this.articleDescription,
    required this.authorName,
    required this.categoryName,
    required this.status,
    required this.assignedAt,
    this.completedAt,
    this.averageScore,
    required this.hasEvaluations,
  });

  @override
  List<Object?> get props => [
        id,
        articleId,
        articleTitle,
        articleDescription,
        authorName,
        categoryName,
        status,
        assignedAt,
        completedAt,
        averageScore,
        hasEvaluations,
      ];

  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';
  bool get isInProgress => status == 'in_progress';
}

class EvaluationCriteria extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int maxScore;
  final int weight;

  const EvaluationCriteria({
    required this.id,
    required this.name,
    this.description,
    required this.maxScore,
    required this.weight,
  });

  @override
  List<Object?> get props => [id, name, description, maxScore, weight];
}

class JudgeStats extends Equatable {
  final int totalAssignments;
  final int completedEvaluations;
  final int pendingEvaluations;
  final double averageScoreGiven;
  final List<Map<String, dynamic>> recentEvaluations;

  const JudgeStats({
    required this.totalAssignments,
    required this.completedEvaluations,
    required this.pendingEvaluations,
    required this.averageScoreGiven,
    required this.recentEvaluations,
  });

  @override
  List<Object> get props => [
        totalAssignments,
        completedEvaluations,
        pendingEvaluations,
        averageScoreGiven,
        recentEvaluations,
      ];
}
