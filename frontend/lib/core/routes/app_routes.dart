import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart';
import '../../features/admin/presentation/bloc/dashboard/dashboard_bloc.dart';
import '../../features/admin/presentation/bloc/dashboard/dashboard_event.dart';
import '../../features/admin/presentation/bloc/articles/articles_bloc.dart';
import '../../features/admin/presentation/bloc/article_form/article_form_bloc.dart';
import '../../features/admin/presentation/bloc/article_detail/article_detail_bloc.dart';
import '../../features/admin/presentation/bloc/article_detail/article_detail_event.dart';
import '../../features/admin/presentation/bloc/import/import_bloc.dart';
import '../../features/admin/presentation/bloc/judge_assignment/judge_assignment_bloc.dart';
import '../../features/admin/presentation/bloc/evaluations/evaluations_bloc.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/articles_list_page.dart';
import '../../features/admin/presentation/pages/article_form_page.dart';
import '../../features/admin/presentation/pages/article_detail_page.dart';
import '../../features/admin/presentation/pages/import_data_page.dart';
import '../../features/admin/presentation/pages/judge_assignment_page.dart';
import '../../features/admin/presentation/pages/evaluations_page.dart';
import '../../features/admin/presentation/pages/reports_page.dart';
import '../../features/judge/presentation/bloc/judge_dashboard_bloc.dart';
import '../../features/judge/presentation/pages/judge_dashboard_page.dart';
import '../../features/judge/presentation/pages/judge_evaluation_form_page.dart';
import '../../features/judge/presentation/pages/judge_stats_page.dart';
import '../../features/judge/presentation/pages/judge_history_page.dart';
import '../../features/student/presentation/bloc/student_dashboard_bloc.dart';
import '../../features/student/presentation/bloc/qr_generator_bloc.dart';
import '../../features/student/presentation/pages/student_dashboard_page.dart';
import '../../features/student/presentation/pages/qr_generator_page.dart';
import '../../features/student/presentation/pages/qr_scanner_page.dart';
import '../../features/student/presentation/pages/attendance_history_page.dart';
import '../../features/student/presentation/pages/student_stats_page.dart';

class AppRoutes {
  // Admin Routes
  static const String adminDashboard = '/admin/dashboard';
  static const String articlesList = '/admin/articles';
  static const String articleCreate = '/admin/articles/create';
  static const String articleEdit = '/admin/articles/edit';
  static const String articleDetail = '/admin/articles/detail';
  static const String judgeAssignment = '/admin/articles/assign-judges';
  static const String importData = '/admin/import';
  static const String evaluations = '/admin/evaluations';
  static const String reports = '/admin/reports';

  // Judge Routes
  static const String judgeDashboard = '/judge/dashboard';
  static const String judgeEvaluation = '/judge/evaluation';
  static const String judgeStats = '/judge/stats';
  static const String judgeHistory = '/judge/history';

  // Student Routes
  static const String studentDashboard = '/student/dashboard';
  static const String studentQRGenerator = '/student/qr-generator';
  static const String studentQRScanner = '/student/qr-scanner';
  static const String studentHistory = '/student/history';
  static const String studentStats = '/student/stats';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<DashboardBloc>()..add(LoadDashboardEvent()),
            child: const AdminDashboardPage(),
          ),
        );

      case articlesList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ArticlesBloc>(),
            child: const ArticlesListPage(),
          ),
        );

      case articleCreate:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ArticleFormBloc>(),
            child: const ArticleFormPage(),
          ),
        );

      case articleEdit:
        final articleId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ArticleFormBloc>(),
            child: ArticleFormPage(articleId: articleId),
          ),
        );

      case articleDetail:
        final articleId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ArticleDetailBloc>()
              ..add(LoadArticleDetailEvent(articleId)),
            child: ArticleDetailPage(articleId: articleId),
          ),
        );

      case judgeAssignment:
        final articleId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<JudgeAssignmentBloc>(),
            child: JudgeAssignmentPage(articleId: articleId),
          ),
        );

      case importData:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ImportBloc>(),
            child: const ImportDataPage(),
          ),
        );

      case evaluations:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<EvaluationsBloc>(),
            child: const EvaluationsPage(),
          ),
        );

      case reports:
        return MaterialPageRoute(
          builder: (_) => const ReportsPage(),
        );

      // Judge Routes
      case judgeDashboard:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<JudgeDashboardBloc>()
              ..add(LoadMyAssignmentsEvent()),
            child: const JudgeDashboardPage(),
          ),
        );

      case judgeEvaluation:
        final assignmentId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => JudgeEvaluationFormPage(assignmentId: assignmentId),
        );

      case judgeStats:
        return MaterialPageRoute(
          builder: (_) => const JudgeStatsPage(),
        );

      case judgeHistory:
        return MaterialPageRoute(
          builder: (_) => const JudgeHistoryPage(),
        );

      // Student Routes
      case studentDashboard:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<StudentDashboardBloc>()
              ..add(LoadStudentDashboardEvent()),
            child: const StudentDashboardPage(),
          ),
        );

      case studentQRGenerator:
        final articles = settings.arguments as List<Map<String, dynamic>>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QRGeneratorBloc>(),
            child: QRGeneratorPage(articles: articles),
          ),
        );

      case studentQRScanner:
        return MaterialPageRoute(
          builder: (_) => const QRScannerPage(),
        );

      case studentHistory:
        return MaterialPageRoute(
          builder: (_) => const AttendanceHistoryPage(),
        );

      case studentStats:
        return MaterialPageRoute(
          builder: (_) => const StudentStatsPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta no encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
