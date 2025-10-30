import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/dashboard_stats.dart';

part 'dashboard_stats_model.g.dart';

@JsonSerializable()
class DashboardStatsModel {
  @JsonKey(name: 'total_students')
  final int totalStudents;
  @JsonKey(name: 'total_ponentes')
  final int totalPonentes;
  @JsonKey(name: 'total_oyentes')
  final int totalOyentes;
  @JsonKey(name: 'total_judges')
  final int totalJudges;
  @JsonKey(name: 'total_articles')
  final int totalArticles;
  @JsonKey(name: 'total_attendances')
  final int totalAttendances;
  @JsonKey(name: 'articles_by_status')
  final Map<String, int>? articlesByStatus;
  @JsonKey(name: 'top_rated_articles')
  final List<TopArticleModel>? topRatedArticles;

  DashboardStatsModel({
    required this.totalStudents,
    required this.totalPonentes,
    required this.totalOyentes,
    required this.totalJudges,
    required this.totalArticles,
    required this.totalAttendances,
    this.articlesByStatus,
    this.topRatedArticles,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsModelToJson(this);

  DashboardStats toEntity() {
    return DashboardStats(
      totalStudents: totalStudents,
      totalPonentes: totalPonentes,
      totalOyentes: totalOyentes,
      totalJudges: totalJudges,
      totalArticles: totalArticles,
      totalAttendances: totalAttendances,
      articlesByStatus: articlesByStatus ?? {},
      topRatedArticles: topRatedArticles
              ?.map((a) => TopArticle(
                    id: a.id,
                    title: a.title,
                    author: a.author,
                    category: a.category,
                    averageScore: a.averageScore,
                  ))
              .toList() ??
          [],
    );
  }
}

@JsonSerializable()
class TopArticleModel {
  final int id;
  final String title;
  final String author;
  final String category;
  @JsonKey(name: 'average_score')
  final double averageScore;

  TopArticleModel({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.averageScore,
  });

  factory TopArticleModel.fromJson(Map<String, dynamic> json) =>
      _$TopArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopArticleModelToJson(this);
}
