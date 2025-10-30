import 'package:equatable/equatable.dart';

abstract class ArticleDetailEvent extends Equatable {
  const ArticleDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadArticleDetailEvent extends ArticleDetailEvent {
  final int articleId;

  const LoadArticleDetailEvent(this.articleId);

  @override
  List<Object> get props => [articleId];
}

class DeleteArticleEvent extends ArticleDetailEvent {}
