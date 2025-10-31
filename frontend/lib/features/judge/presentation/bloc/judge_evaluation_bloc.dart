import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/judge_assignment.dart';
import '../../domain/usecases/get_assignment_detail.dart';
import '../../domain/usecases/get_evaluation_criteria.dart';
import '../../domain/usecases/submit_evaluation.dart';

// Events
abstract class JudgeEvaluationEvent extends Equatable {
  const JudgeEvaluationEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvaluationFormEvent extends JudgeEvaluationEvent {
  final int assignmentId;

  const LoadEvaluationFormEvent(this.assignmentId);

  @override
  List<Object?> get props => [assignmentId];
}

class UpdateScoreEvent extends JudgeEvaluationEvent {
  final int criteriaId;
  final int score;

  const UpdateScoreEvent({required this.criteriaId, required this.score});

  @override
  List<Object?> get props => [criteriaId, score];
}

class SubmitEvaluationEvent extends JudgeEvaluationEvent {
  final int assignmentId;

  const SubmitEvaluationEvent(this.assignmentId);

  @override
  List<Object?> get props => [assignmentId];
}

// States
abstract class JudgeEvaluationState extends Equatable {
  const JudgeEvaluationState();

  @override
  List<Object?> get props => [];
}

class JudgeEvaluationInitial extends JudgeEvaluationState {}

class JudgeEvaluationLoading extends JudgeEvaluationState {}

class JudgeEvaluationFormReady extends JudgeEvaluationState {
  final JudgeAssignment assignment;
  final List<EvaluationCriteria> criteria;
  final Map<int, int> scores;
  final bool isReadOnly;

  const JudgeEvaluationFormReady({
    required this.assignment,
    required this.criteria,
    required this.scores,
    required this.isReadOnly,
  });

  // Copyable for score updates
  JudgeEvaluationFormReady copyWith({
    Map<int, int>? scores,
  }) {
    return JudgeEvaluationFormReady(
      assignment: assignment,
      criteria: criteria,
      scores: scores ?? this.scores,
      isReadOnly: isReadOnly,
    );
  }

  bool get canSubmit =>
      !isReadOnly && scores.length == criteria.length && !isSubmitting;
  bool get isSubmitting => false;

  @override
  List<Object?> get props => [assignment, criteria, scores, isReadOnly];
}

class JudgeEvaluationSubmitting extends JudgeEvaluationState {
  final JudgeAssignment assignment;
  final List<EvaluationCriteria> criteria;
  final Map<int, int> scores;

  const JudgeEvaluationSubmitting({
    required this.assignment,
    required this.criteria,
    required this.scores,
  });

  @override
  List<Object?> get props => [assignment, criteria, scores];
}

class JudgeEvaluationSubmitted extends JudgeEvaluationState {
  final String message;

  const JudgeEvaluationSubmitted(this.message);

  @override
  List<Object?> get props => [message];
}

class JudgeEvaluationError extends JudgeEvaluationState {
  final String message;

  const JudgeEvaluationError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class JudgeEvaluationBloc
    extends Bloc<JudgeEvaluationEvent, JudgeEvaluationState> {
  final GetAssignmentDetail getAssignmentDetail;
  final GetEvaluationCriteria getEvaluationCriteria;
  final SubmitEvaluation submitEvaluation;

  JudgeEvaluationBloc({
    required this.getAssignmentDetail,
    required this.getEvaluationCriteria,
    required this.submitEvaluation,
  }) : super(JudgeEvaluationInitial()) {
    on<LoadEvaluationFormEvent>(_onLoadEvaluationForm);
    on<UpdateScoreEvent>(_onUpdateScore);
    on<SubmitEvaluationEvent>(_onSubmitEvaluation);
  }

  Future<void> _onLoadEvaluationForm(
    LoadEvaluationFormEvent event,
    Emitter<JudgeEvaluationState> emit,
  ) async {
    emit(JudgeEvaluationLoading());

    // Load assignment detail and criteria in parallel
    final assignmentResult = await getAssignmentDetail(event.assignmentId);
    final criteriaResult = await getEvaluationCriteria();

    // Check if both succeeded
    if (assignmentResult.isLeft() || criteriaResult.isLeft()) {
      final errorMessage = assignmentResult.fold(
        (l) => l.message,
        (r) => criteriaResult.fold((l) => l.message, (r) => ''),
      );
      emit(JudgeEvaluationError(errorMessage));
      return;
    }

    final assignment = assignmentResult.getOrElse(() => throw Exception());
    final criteria = criteriaResult.getOrElse(() => throw Exception());

    // Check if already evaluated (read-only mode)
    final isReadOnly = assignment.hasEvaluations;

    emit(JudgeEvaluationFormReady(
      assignment: assignment,
      criteria: criteria,
      scores: {},
      isReadOnly: isReadOnly,
    ));
  }

  void _onUpdateScore(
    UpdateScoreEvent event,
    Emitter<JudgeEvaluationState> emit,
  ) {
    if (state is JudgeEvaluationFormReady) {
      final currentState = state as JudgeEvaluationFormReady;

      // Don't update if read-only
      if (currentState.isReadOnly) return;

      final updatedScores = Map<int, int>.from(currentState.scores);
      updatedScores[event.criteriaId] = event.score;

      emit(currentState.copyWith(scores: updatedScores));
    }
  }

  Future<void> _onSubmitEvaluation(
    SubmitEvaluationEvent event,
    Emitter<JudgeEvaluationState> emit,
  ) async {
    if (state is! JudgeEvaluationFormReady) return;

    final currentState = state as JudgeEvaluationFormReady;

    // Don't submit if read-only
    if (currentState.isReadOnly) {
      emit(const JudgeEvaluationError(
          'Esta evaluación ya ha sido enviada y no puede modificarse'));
      return;
    }

    // Validate all criteria have scores
    if (currentState.scores.length != currentState.criteria.length) {
      emit(const JudgeEvaluationError(
          'Por favor complete todos los criterios de evaluación'));
      emit(currentState);
      return;
    }

    emit(JudgeEvaluationSubmitting(
      assignment: currentState.assignment,
      criteria: currentState.criteria,
      scores: currentState.scores,
    ));

    final result = await submitEvaluation(event.assignmentId, currentState.scores);

    result.fold(
      (failure) {
        emit(JudgeEvaluationError(failure.message));
        emit(currentState);
      },
      (_) {
        emit(const JudgeEvaluationSubmitted(
            'Evaluación enviada exitosamente. No podrá modificarla.'));
      },
    );
  }
}
