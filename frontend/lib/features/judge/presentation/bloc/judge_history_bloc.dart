import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/judge_assignment.dart';
import '../../domain/usecases/get_my_history.dart';

// Events
abstract class JudgeHistoryEvent extends Equatable {
  const JudgeHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadJudgeHistoryEvent extends JudgeHistoryEvent {}

class RefreshJudgeHistoryEvent extends JudgeHistoryEvent {}

class FilterHistoryByDateEvent extends JudgeHistoryEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterHistoryByDateEvent({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

// States
abstract class JudgeHistoryState extends Equatable {
  const JudgeHistoryState();

  @override
  List<Object?> get props => [];
}

class JudgeHistoryInitial extends JudgeHistoryState {}

class JudgeHistoryLoading extends JudgeHistoryState {}

class JudgeHistoryLoaded extends JudgeHistoryState {
  final List<JudgeAssignment> allHistory;
  final List<JudgeAssignment> filteredHistory;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;

  const JudgeHistoryLoaded({
    required this.allHistory,
    required this.filteredHistory,
    this.filterStartDate,
    this.filterEndDate,
  });

  JudgeHistoryLoaded copyWith({
    List<JudgeAssignment>? filteredHistory,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    bool clearFilters = false,
  }) {
    return JudgeHistoryLoaded(
      allHistory: allHistory,
      filteredHistory: filteredHistory ?? this.filteredHistory,
      filterStartDate: clearFilters ? null : (filterStartDate ?? this.filterStartDate),
      filterEndDate: clearFilters ? null : (filterEndDate ?? this.filterEndDate),
    );
  }

  @override
  List<Object?> get props =>
      [allHistory, filteredHistory, filterStartDate, filterEndDate];
}

class JudgeHistoryError extends JudgeHistoryState {
  final String message;

  const JudgeHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class JudgeHistoryBloc extends Bloc<JudgeHistoryEvent, JudgeHistoryState> {
  final GetMyHistory getMyHistory;

  JudgeHistoryBloc({required this.getMyHistory})
      : super(JudgeHistoryInitial()) {
    on<LoadJudgeHistoryEvent>(_onLoadHistory);
    on<RefreshJudgeHistoryEvent>(_onRefreshHistory);
    on<FilterHistoryByDateEvent>(_onFilterByDate);
  }

  Future<void> _onLoadHistory(
    LoadJudgeHistoryEvent event,
    Emitter<JudgeHistoryState> emit,
  ) async {
    emit(JudgeHistoryLoading());
    await _fetchHistory(emit);
  }

  Future<void> _onRefreshHistory(
    RefreshJudgeHistoryEvent event,
    Emitter<JudgeHistoryState> emit,
  ) async {
    await _fetchHistory(emit);
  }

  Future<void> _fetchHistory(Emitter<JudgeHistoryState> emit) async {
    final result = await getMyHistory();

    result.fold(
      (failure) => emit(JudgeHistoryError(failure.message)),
      (history) {
        // Sort by completed_at descending (most recent first)
        final sortedHistory = List<JudgeAssignment>.from(history)
          ..sort((a, b) {
            if (a.completedAt == null) return 1;
            if (b.completedAt == null) return -1;
            return b.completedAt!.compareTo(a.completedAt!);
          });

        emit(JudgeHistoryLoaded(
          allHistory: sortedHistory,
          filteredHistory: sortedHistory,
        ));
      },
    );
  }

  void _onFilterByDate(
    FilterHistoryByDateEvent event,
    Emitter<JudgeHistoryState> emit,
  ) {
    if (state is! JudgeHistoryLoaded) return;

    final currentState = state as JudgeHistoryLoaded;

    // If no dates provided, show all
    if (event.startDate == null && event.endDate == null) {
      emit(currentState.copyWith(
        filteredHistory: currentState.allHistory,
        clearFilters: true,
      ));
      return;
    }

    // Filter by date range
    final filtered = currentState.allHistory.where((assignment) {
      if (assignment.completedAt == null) return false;

      final completedDate = assignment.completedAt!;

      if (event.startDate != null && completedDate.isBefore(event.startDate!)) {
        return false;
      }

      if (event.endDate != null && completedDate.isAfter(event.endDate!)) {
        return false;
      }

      return true;
    }).toList();

    emit(currentState.copyWith(
      filteredHistory: filtered,
      filterStartDate: event.startDate,
      filterEndDate: event.endDate,
    ));
  }
}
