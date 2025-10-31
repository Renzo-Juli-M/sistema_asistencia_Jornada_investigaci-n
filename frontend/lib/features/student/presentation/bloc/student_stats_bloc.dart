import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/student_attendance.dart';
import '../../domain/usecases/get_my_stats.dart';

// Events
abstract class StudentStatsEvent extends Equatable {
  const StudentStatsEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudentStatsEvent extends StudentStatsEvent {}

class RefreshStatsEvent extends StudentStatsEvent {}

// States
abstract class StudentStatsState extends Equatable {
  const StudentStatsState();

  @override
  List<Object?> get props => [];
}

class StudentStatsInitial extends StudentStatsState {}

class StudentStatsLoading extends StudentStatsState {}

class StudentStatsLoaded extends StudentStatsState {
  final StudentStats stats;

  const StudentStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class StudentStatsError extends StudentStatsState {
  final String message;

  const StudentStatsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class StudentStatsBloc extends Bloc<StudentStatsEvent, StudentStatsState> {
  final GetMyStats getMyStats;

  StudentStatsBloc({required this.getMyStats}) : super(StudentStatsInitial()) {
    on<LoadStudentStatsEvent>(_onLoadStats);
    on<RefreshStatsEvent>(_onRefreshStats);
  }

  Future<void> _onLoadStats(
    LoadStudentStatsEvent event,
    Emitter<StudentStatsState> emit,
  ) async {
    emit(StudentStatsLoading());
    await _fetchStats(emit);
  }

  Future<void> _onRefreshStats(
    RefreshStatsEvent event,
    Emitter<StudentStatsState> emit,
  ) async {
    await _fetchStats(emit);
  }

  Future<void> _fetchStats(Emitter<StudentStatsState> emit) async {
    final result = await getMyStats();

    result.fold(
      (failure) => emit(StudentStatsError(failure.message)),
      (stats) => emit(StudentStatsLoaded(stats)),
    );
  }
}
