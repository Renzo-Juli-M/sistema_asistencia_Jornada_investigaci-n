import 'package:json_annotation/json_annotation.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/article.dart';
import 'category_model.dart';

part 'article_model.g.dart';

@JsonSerializable()
class ArticleModel {
  final int id;
  final String title;
  final String? description;
  final String? abstract;
  final String? keywords;
  final String status;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'category_id')
  final int? categoryId;
  final UserModel? user;
  final CategoryModel? category;
  @JsonKey(name: 'judges_count')
  final int judgesCount;
  @JsonKey(name: 'average_score')
  final double averageScore;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  ArticleModel({
    required this.id,
    required this.title,
    this.description,
    this.abstract,
    this.keywords,
    required this.status,
    required this.userId,
    this.categoryId,
    this.user,
    this.category,
    this.judgesCount = 0,
    this.averageScore = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);

  Article toEntity() {
    return Article(
      id: id,
      title: title,
      description: description,
      abstract: abstract,
      keywords: keywords,
      userId: userId,
      authorName: user?.name ?? 'Desconocido',
      categoryId: categoryId,
      categoryName: category?.name,
      status: status,
      judgesCount: judgesCount,
      averageScore: averageScore,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}

@JsonSerializable()
class ArticleListResponseModel {
  final List<ArticleModel> data;
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'last_page')
  final int lastPage;
  @JsonKey(name: 'per_page')
  final int perPage;
  final int total;

  ArticleListResponseModel({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ArticleListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleListResponseModelFromJson(json);

  ArticleListResponse toEntity() {
    return ArticleListResponse(
      data: data.map((article) => article.toEntity()).toList(),
      currentPage: currentPage,
      lastPage: lastPage,
      total: total,
      perPage: perPage,
    );
  }
}

