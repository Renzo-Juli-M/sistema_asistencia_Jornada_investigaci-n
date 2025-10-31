import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/judge_assignment.dart';
import '../../domain/usecases/get_my_stats.dart';

// Events
abstract class JudgeStatsEvent extends Equatable {
  const JudgeStatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadJudgeStatsEvent extends JudgeStatsEvent {}

class RefreshJudgeStatsEvent extends JudgeStatsEvent {}

// States
abstract class JudgeStatsState extends Equatable {
  const JudgeStatsState();

  @override
  List<Object?> get props => [];
}

class JudgeStatsInitial extends JudgeStatsState {}

class JudgeStatsLoading extends JudgeStatsState {}

class JudgeStatsLoaded extends JudgeStatsState {
  final JudgeStats stats;

  const JudgeStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class JudgeStatsError extends JudgeStatsState {
  final String message;

  const JudgeStatsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class JudgeStatsBloc extends Bloc<JudgeStatsEvent, JudgeStatsState> {
  final GetMyStats getMyStats;

  JudgeStatsBloc({required this.getMyStats}) : super(JudgeStatsInitial()) {
    on<LoadJudgeStatsEvent>(_onLoadStats);
    on<RefreshJudgeStatsEvent>(_onRefreshStats);
  }

  Future<void> _onLoadStats(
    LoadJudgeStatsEvent event,
    Emitter<JudgeStatsState> emit,
  ) async {
    emit(JudgeStatsLoading());
    await _fetchStats(emit);
  }

  Future<void> _onRefreshStats(
    RefreshJudgeStatsEvent event,
    Emitter<JudgeStatsState> emit,
  ) async {
    await _fetchStats(emit);
  }

  Future<void> _fetchStats(Emitter<JudgeStatsState> emit) async {
    final result = await getMyStats();

    result.fold(
      (failure) => emit(JudgeStatsError(failure.message)),
      (stats) => emit(JudgeStatsLoaded(stats)),
    );
  }
}
