import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_articles.dart';
import '../../../domain/usecases/delete_article.dart';
import 'articles_event.dart';
import 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final GetArticles getArticles;
  final DeleteArticle deleteArticle;

  ArticlesBloc({
    required this.getArticles,
    required this.deleteArticle,
  }) : super(ArticlesInitial()) {
    on<LoadArticlesEvent>(_onLoadArticles);
    on<DeleteArticleEvent>(_onDeleteArticle);
  }

  Future<void> _onLoadArticles(
    LoadArticlesEvent event,
    Emitter<ArticlesState> emit,
  ) async {
    emit(ArticlesLoading());

    final params = <String, dynamic>{
      if (event.search != null) 'search': event.search,
      if (event.status != null) 'status': event.status,
      if (event.categoryId != null) 'category_id': event.categoryId,
      if (event.userId != null) 'user_id': event.userId,
      'page': event.page,
    };

    final result = await getArticles(params);

    result.fold(
      (failure) => emit(ArticlesError(failure.message)),
      (response) => emit(ArticlesLoaded(
        articles: response.data,
        currentPage: response.currentPage,
        lastPage: response.lastPage,
        total: response.total,
      )),
    );
  }

  Future<void> _onDeleteArticle(
    DeleteArticleEvent event,
    Emitter<ArticlesState> emit,
  ) async {
    final result = await deleteArticle(event.articleId);

    result.fold(
      (failure) => emit(ArticlesError(failure.message)),
      (_) => emit(const ArticleDeleted('Artículo eliminado exitosamente')),
    );
  }
}
