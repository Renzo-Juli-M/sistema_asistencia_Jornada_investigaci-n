import 'package:equatable/equatable.dart';
import '../../../domain/entities/article.dart';

abstract class ArticlesState extends Equatable {
  const ArticlesState();

  @override
  List<Object> get props => [];
}

class ArticlesInitial extends ArticlesState {}

class ArticlesLoading extends ArticlesState {}

class ArticlesLoaded extends ArticlesState {
  final List<Article> articles;
  final int currentPage;
  final int lastPage;
  final int total;

  const ArticlesLoaded({
    required this.articles,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  @override
  List<Object> get props => [articles, currentPage, lastPage, total];
}

class ArticlesError extends ArticlesState {
  final String message;

  const ArticlesError(this.message);

  @override
  List<Object> get props => [message];
}

class ArticleDeleted extends ArticlesState {
  final String message;

  const ArticleDeleted(this.message);

  @override
  List<Object> get props => [message];
}
