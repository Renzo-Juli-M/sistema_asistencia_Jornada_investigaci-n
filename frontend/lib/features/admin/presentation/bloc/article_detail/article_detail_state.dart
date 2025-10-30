import 'package:equatable/equatable.dart';
import '../../../domain/entities/article.dart';

abstract class ArticleDetailState extends Equatable {
  const ArticleDetailState();

  @override
  List<Object> get props => [];
}

class ArticleDetailInitial extends ArticleDetailState {}

class ArticleDetailLoading extends ArticleDetailState {}

class ArticleDetailLoaded extends ArticleDetailState {
  final Article article;
  final List<Map<String, dynamic>> assignments;
  final List<Map<String, dynamic>> evaluations;

  const ArticleDetailLoaded({
    required this.article,
    required this.assignments,
    required this.evaluations,
  });

  @override
  List<Object> get props => [article, assignments, evaluations];
}

class ArticleDetailError extends ArticleDetailState {
  final String message;

  const ArticleDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class ArticleDeleted extends ArticleDetailState {}
