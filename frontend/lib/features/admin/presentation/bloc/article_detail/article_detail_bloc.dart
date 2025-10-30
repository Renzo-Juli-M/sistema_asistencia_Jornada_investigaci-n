import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_article_detail.dart';
import '../../../domain/usecases/delete_article.dart';
import '../../../data/models/article_model.dart';
import 'article_detail_event.dart';
import 'article_detail_state.dart';

class ArticleDetailBloc extends Bloc<ArticleDetailEvent, ArticleDetailState> {
  final GetArticleDetail getArticleDetail;
  final DeleteArticle deleteArticle;
  int? _currentArticleId;

  ArticleDetailBloc({
    required this.getArticleDetail,
    required this.deleteArticle,
  }) : super(ArticleDetailInitial()) {
    on<LoadArticleDetailEvent>(_onLoadArticleDetail);
    on<DeleteArticleEvent>(_onDeleteArticle);
  }

  Future<void> _onLoadArticleDetail(
    LoadArticleDetailEvent event,
    Emitter<ArticleDetailState> emit,
  ) async {
    emit(ArticleDetailLoading());
    _currentArticleId = event.articleId;

    final result = await getArticleDetail(event.articleId);

    result.fold(
      (failure) => emit(ArticleDetailError(failure.message)),
      (data) {
        // Parse the article data
        final articleModel = ArticleModel.fromJson(data['article']);
        final article = articleModel.toEntity();

        // Get assignments and evaluations
        final assignments = (data['assignments'] as List?)
            ?.cast<Map<String, dynamic>>() ?? [];
        final evaluations = (data['evaluations'] as List?)
            ?.cast<Map<String, dynamic>>() ?? [];

        emit(ArticleDetailLoaded(
          article: article,
          assignments: assignments,
          evaluations: evaluations,
        ));
      },
    );
  }

  Future<void> _onDeleteArticle(
    DeleteArticleEvent event,
    Emitter<ArticleDetailState> emit,
  ) async {
    if (_currentArticleId == null) return;

    final result = await deleteArticle(_currentArticleId!);

    result.fold(
      (failure) => emit(ArticleDetailError(failure.message)),
      (_) => emit(ArticleDeleted()),
    );
  }
}
