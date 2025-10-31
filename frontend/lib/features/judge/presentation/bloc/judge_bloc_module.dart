import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_assignment_detail.dart';
import '../../domain/usecases/get_evaluation_criteria.dart';
import '../../domain/usecases/get_my_assignments.dart';
import '../../domain/usecases/get_my_history.dart';
import '../../domain/usecases/get_my_stats.dart';
import '../../domain/usecases/submit_evaluation.dart';
import 'judge_dashboard_bloc.dart';
import 'judge_evaluation_bloc.dart';
import 'judge_history_bloc.dart';
import 'judge_stats_bloc.dart';

@module
abstract class JudgeBlocModule {
  @injectable
  JudgeDashboardBloc judgeDashboardBloc(GetMyAssignments getMyAssignments) =>
      JudgeDashboardBloc(getMyAssignments: getMyAssignments);

  @injectable
  JudgeEvaluationBloc judgeEvaluationBloc(
    GetAssignmentDetail getAssignmentDetail,
    GetEvaluationCriteria getEvaluationCriteria,
    SubmitEvaluation submitEvaluation,
  ) =>
      JudgeEvaluationBloc(
        getAssignmentDetail: getAssignmentDetail,
        getEvaluationCriteria: getEvaluationCriteria,
        submitEvaluation: submitEvaluation,
      );

  @injectable
  JudgeStatsBloc judgeStatsBloc(GetMyStats getMyStats) =>
      JudgeStatsBloc(getMyStats: getMyStats);

  @injectable
  JudgeHistoryBloc judgeHistoryBloc(GetMyHistory getMyHistory) =>
      JudgeHistoryBloc(getMyHistory: getMyHistory);
}
