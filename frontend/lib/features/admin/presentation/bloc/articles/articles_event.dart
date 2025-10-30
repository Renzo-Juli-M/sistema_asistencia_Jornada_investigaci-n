import 'package:equatable/equatable.dart';

abstract class ArticlesEvent extends Equatable {
  const ArticlesEvent();

  @override
  List<Object?> get props => [];
}

class LoadArticlesEvent extends ArticlesEvent {
  final String? search;
  final String? status;
  final int? categoryId;
  final int? userId;
  final int page;

  const LoadArticlesEvent({
    this.search,
    this.status,
    this.categoryId,
    this.userId,
    this.page = 1,
  });

  @override
  List<Object?> get props => [search, status, categoryId, userId, page];
}

class DeleteArticleEvent extends ArticlesEvent {
  final int articleId;

  const DeleteArticleEvent(this.articleId);

  @override
  List<Object> get props => [articleId];
}
