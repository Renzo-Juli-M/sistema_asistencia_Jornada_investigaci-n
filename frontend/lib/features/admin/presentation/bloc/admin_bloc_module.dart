import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_dashboard_stats.dart';
import '../../domain/usecases/get_articles.dart';
import '../../domain/usecases/delete_article.dart';
import '../../domain/usecases/create_article.dart';
import '../../domain/usecases/update_article.dart';
import '../../domain/usecases/get_article.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_students.dart';
import '../../domain/usecases/import_students.dart';
import '../../domain/usecases/import_judges.dart';
import '../../domain/usecases/import_articles.dart';
import '../../domain/usecases/get_article_detail.dart';
import '../../domain/usecases/get_available_judges.dart';
import '../../domain/usecases/assign_judges.dart';
import '../../domain/usecases/get_evaluations.dart';
import 'dashboard/dashboard_bloc.dart';
import 'articles/articles_bloc.dart';
import 'article_form/article_form_bloc.dart';
import 'article_detail/article_detail_bloc.dart';
import 'import/import_bloc.dart';
import 'judge_assignment/judge_assignment_bloc.dart';
import 'evaluations/evaluations_bloc.dart';

@module
abstract class AdminBlocModule {
  @injectable
  DashboardBloc dashboardBloc(GetDashboardStats getDashboardStats) =>
      DashboardBloc(getDashboardStats: getDashboardStats);

  @injectable
  ArticlesBloc articlesBloc(
    GetArticles getArticles,
    DeleteArticle deleteArticle,
  ) =>
      ArticlesBloc(
        getArticles: getArticles,
        deleteArticle: deleteArticle,
      );

  @injectable
  ArticleFormBloc articleFormBloc(
    CreateArticle createArticle,
    UpdateArticle updateArticle,
    GetArticle getArticle,
    GetCategories getCategories,
    GetStudents getStudents,
  ) =>
      ArticleFormBloc(
        createArticle: createArticle,
        updateArticle: updateArticle,
        getArticle: getArticle,
        getCategories: getCategories,
        getStudents: getStudents,
      );

  @injectable
  ArticleDetailBloc articleDetailBloc(
    GetArticleDetail getArticleDetail,
    DeleteArticle deleteArticle,
  ) =>
      ArticleDetailBloc(
        getArticleDetail: getArticleDetail,
        deleteArticle: deleteArticle,
      );

  @injectable
  ImportBloc importBloc(
    ImportStudents importStudents,
    ImportJudges importJudges,
    ImportArticles importArticles,
  ) =>
      ImportBloc(
        importStudents: importStudents,
        importJudges: importJudges,
        importArticles: importArticles,
      );

  @injectable
  JudgeAssignmentBloc judgeAssignmentBloc(
    GetAvailableJudges getAvailableJudges,
    AssignJudges assignJudges,
  ) =>
      JudgeAssignmentBloc(
        getAvailableJudges: getAvailableJudges,
        assignJudges: assignJudges,
      );

  @injectable
  EvaluationsBloc evaluationsBloc(GetEvaluations getEvaluations) =>
      EvaluationsBloc(getEvaluations: getEvaluations);
}
