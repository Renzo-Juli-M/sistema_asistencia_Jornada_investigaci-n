import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String? abstract;
  final String? keywords;
  final int userId;
  final String authorName;
  final int? categoryId;
  final String? categoryName;
  final String status;
  final int judgesCount;
  final double averageScore;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Article({
    required this.id,
    required this.title,
    this.description,
    this.abstract,
    this.keywords,
    required this.userId,
    required this.authorName,
    this.categoryId,
    this.categoryName,
    required this.status,
    required this.judgesCount,
    required this.averageScore,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        abstract,
        keywords,
        userId,
        authorName,
        categoryId,
        categoryName,
        status,
        judgesCount,
        averageScore,
        createdAt,
        updatedAt,
      ];
}

class ArticleListResponse extends Equatable {
  final List<Article> data;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  const ArticleListResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  @override
  List<Object> get props => [data, currentPage, lastPage, total, perPage];
}
