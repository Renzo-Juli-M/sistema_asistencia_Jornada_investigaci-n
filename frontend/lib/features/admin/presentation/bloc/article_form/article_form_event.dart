import 'package:equatable/equatable.dart';

abstract class ArticleFormEvent extends Equatable {
  const ArticleFormEvent();

  @override
  List<Object?> get props => [];
}

class LoadFormDataEvent extends ArticleFormEvent {}

class LoadArticleEvent extends ArticleFormEvent {
  final int articleId;

  const LoadArticleEvent(this.articleId);

  @override
  List<Object> get props => [articleId];
}

class CreateArticleEvent extends ArticleFormEvent {
  final Map<String, dynamic> data;

  const CreateArticleEvent(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateArticleEvent extends ArticleFormEvent {
  final int articleId;
  final Map<String, dynamic> data;

  const UpdateArticleEvent(this.articleId, this.data);

  @override
  List<Object> get props => [articleId, data];
}
