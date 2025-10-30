import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int totalStudents;
  final int totalPonentes;
  final int totalOyentes;
  final int totalJudges;
  final int totalArticles;
  final int totalAttendances;
  final Map<String, int> articlesByStatus;
  final List<TopArticle> topRatedArticles;

  const DashboardStats({
    required this.totalStudents,
    required this.totalPonentes,
    required this.totalOyentes,
    required this.totalJudges,
    required this.totalArticles,
    required this.totalAttendances,
    required this.articlesByStatus,
    required this.topRatedArticles,
  });

  @override
  List<Object?> get props => [
        totalStudents,
        totalPonentes,
        totalOyentes,
        totalJudges,
        totalArticles,
        totalAttendances,
        articlesByStatus,
        topRatedArticles,
      ];
}

class TopArticle extends Equatable {
  final int id;
  final String title;
  final String author;
  final String category;
  final double averageScore;

  const TopArticle({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.averageScore,
  });

  @override
  List<Object?> get props => [id, title, author, category, averageScore];
}
