import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_article.dart';
import '../../../domain/usecases/update_article.dart';
import '../../../domain/usecases/get_article.dart';
import '../../../domain/usecases/get_categories.dart';
import '../../../domain/usecases/get_students.dart';
import 'article_form_event.dart';
import 'article_form_state.dart';

class ArticleFormBloc extends Bloc<ArticleFormEvent, ArticleFormState> {
  final CreateArticle createArticle;
  final UpdateArticle updateArticle;
  final GetArticle getArticle;
  final GetCategories getCategories;
  final GetStudents getStudents;

  ArticleFormBloc({
    required this.createArticle,
    required this.updateArticle,
    required this.getArticle,
    required this.getCategories,
    required this.getStudents,
  }) : super(ArticleFormInitial()) {
    on<LoadFormDataEvent>(_onLoadFormData);
    on<LoadArticleEvent>(_onLoadArticle);
    on<CreateArticleEvent>(_onCreateArticle);
    on<UpdateArticleEvent>(_onUpdateArticle);
  }

  Future<void> _onLoadFormData(
    LoadFormDataEvent event,
    Emitter<ArticleFormState> emit,
  ) async {
    emit(ArticleFormLoading());

    try {
      final categoriesResult = await getCategories();
      final studentsResult = await getStudents();

      final categories = categoriesResult.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );

      final students = studentsResult.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );

      emit(ArticleFormLoaded(
        categories: categories,
        students: students,
      ));
    } catch (e) {
      emit(ArticleFormError(e.toString()));
    }
  }

  Future<void> _onLoadArticle(
    LoadArticleEvent event,
    Emitter<ArticleFormState> emit,
  ) async {
    emit(ArticleFormLoading());

    try {
      final categoriesResult = await getCategories();
      final studentsResult = await getStudents();
      final articleResult = await getArticle(event.articleId);

      final categories = categoriesResult.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );

      final students = studentsResult.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );

      final article = articleResult.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );

      emit(ArticleFormLoaded(
        categories: categories,
        students: students,
        article: article,
      ));
    } catch (e) {
      emit(ArticleFormError(e.toString()));
    }
  }

  Future<void> _onCreateArticle(
    CreateArticleEvent event,
    Emitter<ArticleFormState> emit,
  ) async {
    emit(ArticleFormSubmitting());

    final result = await createArticle(event.data);

    result.fold(
      (failure) => emit(ArticleFormError(failure.message)),
      (article) => emit(const ArticleFormSuccess('Artículo creado exitosamente')),
    );
  }

  Future<void> _onUpdateArticle(
    UpdateArticleEvent event,
    Emitter<ArticleFormState> emit,
  ) async {
    emit(ArticleFormSubmitting());

    final result = await updateArticle(event.articleId, event.data);

    result.fold(
      (failure) => emit(ArticleFormError(failure.message)),
      (article) => emit(const ArticleFormSuccess('Artículo actualizado exitosamente')),
    );
  }
}
