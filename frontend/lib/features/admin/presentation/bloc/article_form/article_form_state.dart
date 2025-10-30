import 'package:equatable/equatable.dart';
import '../../../data/models/article_model.dart';
import '../../../data/models/category_model.dart';

abstract class ArticleFormState extends Equatable {
  const ArticleFormState();

  @override
  List<Object?> get props => [];
}

class ArticleFormInitial extends ArticleFormState {}

class ArticleFormLoading extends ArticleFormState {}

class ArticleFormLoaded extends ArticleFormState {
  final List<CategoryModel> categories;
  final List<Map<String, dynamic>> students;
  final ArticleModel? article; // For edit mode

  const ArticleFormLoaded({
    required this.categories,
    required this.students,
    this.article,
  });

  @override
  List<Object?> get props => [categories, students, article];
}

class ArticleFormSubmitting extends ArticleFormState {}

class ArticleFormSuccess extends ArticleFormState {
  final String message;

  const ArticleFormSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ArticleFormError extends ArticleFormState {
  final String message;

  const ArticleFormError(this.message);

  @override
  List<Object> get props => [message];
}
