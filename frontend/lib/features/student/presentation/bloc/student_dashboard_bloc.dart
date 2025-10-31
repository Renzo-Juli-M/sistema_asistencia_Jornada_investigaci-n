import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/student_attendance.dart';
import '../../domain/usecases/get_my_articles.dart';
import '../../domain/usecases/get_my_stats.dart';

// Events
abstract class StudentDashboardEvent extends Equatable {
  const StudentDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudentDashboardEvent extends StudentDashboardEvent {}

class RefreshDashboardEvent extends StudentDashboardEvent {}

// States
abstract class StudentDashboardState extends Equatable {
  const StudentDashboardState();

  @override
  List<Object?> get props => [];
}

class StudentDashboardInitial extends StudentDashboardState {}

class StudentDashboardLoading extends StudentDashboardState {}

class StudentDashboardLoaded extends StudentDashboardState {
  final List<Map<String, dynamic>> myArticles;
  final StudentStats stats;

  const StudentDashboardLoaded({
    required this.myArticles,
    required this.stats,
  });

  @override
  List<Object?> get props => [myArticles, stats];
}

class StudentDashboardError extends StudentDashboardState {
  final String message;

  const StudentDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class StudentDashboardBloc
    extends Bloc<StudentDashboardEvent, StudentDashboardState> {
  final GetMyArticles getMyArticles;
  final GetMyStats getMyStats;

  StudentDashboardBloc({
    required this.getMyArticles,
    required this.getMyStats,
  }) : super(StudentDashboardInitial()) {
    on<LoadStudentDashboardEvent>(_onLoadDashboard);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadStudentDashboardEvent event,
    Emitter<StudentDashboardState> emit,
  ) async {
    emit(StudentDashboardLoading());
    await _fetchData(emit);
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<StudentDashboardState> emit,
  ) async {
    await _fetchData(emit);
  }

  Future<void> _fetchData(Emitter<StudentDashboardState> emit) async {
    final articlesResult = await getMyArticles();
    final statsResult = await getMyStats();

    if (articlesResult.isLeft() || statsResult.isLeft()) {
      final errorMessage = articlesResult.fold(
        (l) => l.message,
        (r) => statsResult.fold((l) => l.message, (r) => ''),
      );
      emit(StudentDashboardError(errorMessage));
      return;
    }

    final articles = articlesResult.getOrElse(() => []);
    final stats = statsResult.getOrElse(() => throw Exception());

    emit(StudentDashboardLoaded(
      myArticles: articles,
      stats: stats,
    ));
  }
}
