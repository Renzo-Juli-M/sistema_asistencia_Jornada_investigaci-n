import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/judge_assignment.dart';
import '../../domain/usecases/get_my_assignments.dart';

// Events
abstract class JudgeDashboardEvent extends Equatable {
  const JudgeDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyAssignmentsEvent extends JudgeDashboardEvent {}

class RefreshAssignmentsEvent extends JudgeDashboardEvent {}

// States
abstract class JudgeDashboardState extends Equatable {
  const JudgeDashboardState();

  @override
  List<Object?> get props => [];
}

class JudgeDashboardInitial extends JudgeDashboardState {}

class JudgeDashboardLoading extends JudgeDashboardState {}

class JudgeDashboardLoaded extends JudgeDashboardState {
  final List<JudgeAssignment> assignments;
  final List<JudgeAssignment> pendingAssignments;
  final List<JudgeAssignment> inProgressAssignments;
  final List<JudgeAssignment> completedAssignments;

  const JudgeDashboardLoaded({
    required this.assignments,
    required this.pendingAssignments,
    required this.inProgressAssignments,
    required this.completedAssignments,
  });

  @override
  List<Object?> get props => [
        assignments,
        pendingAssignments,
        inProgressAssignments,
        completedAssignments,
      ];
}

class JudgeDashboardError extends JudgeDashboardState {
  final String message;

  const JudgeDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class JudgeDashboardBloc
    extends Bloc<JudgeDashboardEvent, JudgeDashboardState> {
  final GetMyAssignments getMyAssignments;

  JudgeDashboardBloc({required this.getMyAssignments})
      : super(JudgeDashboardInitial()) {
    on<LoadMyAssignmentsEvent>(_onLoadMyAssignments);
    on<RefreshAssignmentsEvent>(_onRefreshAssignments);
  }

  Future<void> _onLoadMyAssignments(
    LoadMyAssignmentsEvent event,
    Emitter<JudgeDashboardState> emit,
  ) async {
    emit(JudgeDashboardLoading());
    await _fetchAssignments(emit);
  }

  Future<void> _onRefreshAssignments(
    RefreshAssignmentsEvent event,
    Emitter<JudgeDashboardState> emit,
  ) async {
    await _fetchAssignments(emit);
  }

  Future<void> _fetchAssignments(Emitter<JudgeDashboardState> emit) async {
    final result = await getMyAssignments();

    result.fold(
      (failure) => emit(JudgeDashboardError(failure.message)),
      (assignments) {
        // Separate assignments by status
        final pending =
            assignments.where((a) => a.status == 'pending').toList();
        final inProgress =
            assignments.where((a) => a.status == 'in_progress').toList();
        final completed =
            assignments.where((a) => a.status == 'completed').toList();

        emit(JudgeDashboardLoaded(
          assignments: assignments,
          pendingAssignments: pending,
          inProgressAssignments: inProgress,
          completedAssignments: completed,
        ));
      },
    );
  }
}
