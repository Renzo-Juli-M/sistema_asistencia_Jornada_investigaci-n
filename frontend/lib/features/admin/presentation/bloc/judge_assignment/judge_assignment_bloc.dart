import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_available_judges.dart';
import '../../../domain/usecases/assign_judges.dart';
import 'judge_assignment_event.dart';
import 'judge_assignment_state.dart';

class JudgeAssignmentBloc extends Bloc<JudgeAssignmentEvent, JudgeAssignmentState> {
  final GetAvailableJudges getAvailableJudges;
  final AssignJudges assignJudges;

  JudgeAssignmentBloc({
    required this.getAvailableJudges,
    required this.assignJudges,
  }) : super(JudgeAssignmentInitial()) {
    on<LoadAvailableJudgesEvent>(_onLoadAvailableJudges);
    on<AssignJudgesEvent>(_onAssignJudges);
  }

  Future<void> _onLoadAvailableJudges(
    LoadAvailableJudgesEvent event,
    Emitter<JudgeAssignmentState> emit,
  ) async {
    emit(JudgeAssignmentLoading());

    final result = await getAvailableJudges(event.articleId);

    result.fold(
      (failure) => emit(JudgeAssignmentError(failure.message)),
      (judges) => emit(JudgeAssignmentLoaded(judges)),
    );
  }

  Future<void> _onAssignJudges(
    AssignJudgesEvent event,
    Emitter<JudgeAssignmentState> emit,
  ) async {
    emit(JudgeAssignmentAssigning());

    final result = await assignJudges(event.articleId, event.judgeIds);

    result.fold(
      (failure) => emit(JudgeAssignmentError(failure.message)),
      (_) => emit(const JudgeAssignmentSuccess(
        'Jurados asignados exitosamente',
      )),
    );
  }
}
