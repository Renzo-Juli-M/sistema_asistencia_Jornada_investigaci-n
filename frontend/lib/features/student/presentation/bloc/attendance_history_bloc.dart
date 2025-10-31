import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/student_attendance.dart';
import '../../domain/usecases/get_my_attendance_history.dart';

// Events
abstract class AttendanceHistoryEvent extends Equatable {
  const AttendanceHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadAttendanceHistoryEvent extends AttendanceHistoryEvent {}

class RefreshHistoryEvent extends AttendanceHistoryEvent {}

class FilterByTypeEvent extends AttendanceHistoryEvent {
  final String? type; // 'ponente', 'oyente', or null for all

  const FilterByTypeEvent(this.type);

  @override
  List<Object?> get props => [type];
}

// States
abstract class AttendanceHistoryState extends Equatable {
  const AttendanceHistoryState();

  @override
  List<Object?> get props => [];
}

class AttendanceHistoryInitial extends AttendanceHistoryState {}

class AttendanceHistoryLoading extends AttendanceHistoryState {}

class AttendanceHistoryLoaded extends AttendanceHistoryState {
  final List<StudentAttendance> allHistory;
  final List<StudentAttendance> filteredHistory;
  final String? filterType;

  const AttendanceHistoryLoaded({
    required this.allHistory,
    required this.filteredHistory,
    this.filterType,
  });

  AttendanceHistoryLoaded copyWith({
    List<StudentAttendance>? filteredHistory,
    String? filterType,
    bool clearFilter = false,
  }) {
    return AttendanceHistoryLoaded(
      allHistory: allHistory,
      filteredHistory: filteredHistory ?? this.filteredHistory,
      filterType: clearFilter ? null : (filterType ?? this.filterType),
    );
  }

  @override
  List<Object?> get props => [allHistory, filteredHistory, filterType];
}

class AttendanceHistoryError extends AttendanceHistoryState {
  final String message;

  const AttendanceHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class AttendanceHistoryBloc
    extends Bloc<AttendanceHistoryEvent, AttendanceHistoryState> {
  final GetMyAttendanceHistory getMyAttendanceHistory;

  AttendanceHistoryBloc({
    required this.getMyAttendanceHistory,
  }) : super(AttendanceHistoryInitial()) {
    on<LoadAttendanceHistoryEvent>(_onLoadHistory);
    on<RefreshHistoryEvent>(_onRefreshHistory);
    on<FilterByTypeEvent>(_onFilterByType);
  }

  Future<void> _onLoadHistory(
    LoadAttendanceHistoryEvent event,
    Emitter<AttendanceHistoryState> emit,
  ) async {
    emit(AttendanceHistoryLoading());
    await _fetchHistory(emit);
  }

  Future<void> _onRefreshHistory(
    RefreshHistoryEvent event,
    Emitter<AttendanceHistoryState> emit,
  ) async {
    await _fetchHistory(emit);
  }

  Future<void> _fetchHistory(Emitter<AttendanceHistoryState> emit) async {
    final result = await getMyAttendanceHistory();

    result.fold(
      (failure) => emit(AttendanceHistoryError(failure.message)),
      (history) {
        // Sort by date descending
        final sortedHistory = List<StudentAttendance>.from(history)
          ..sort((a, b) => b.registeredAt.compareTo(a.registeredAt));

        emit(AttendanceHistoryLoaded(
          allHistory: sortedHistory,
          filteredHistory: sortedHistory,
        ));
      },
    );
  }

  void _onFilterByType(
    FilterByTypeEvent event,
    Emitter<AttendanceHistoryState> emit,
  ) {
    if (state is! AttendanceHistoryLoaded) return;

    final currentState = state as AttendanceHistoryLoaded;

    if (event.type == null) {
      // Show all
      emit(currentState.copyWith(
        filteredHistory: currentState.allHistory,
        clearFilter: true,
      ));
      return;
    }

    final filtered = currentState.allHistory
        .where((attendance) => attendance.studentType == event.type)
        .toList();

    emit(currentState.copyWith(
      filteredHistory: filtered,
      filterType: event.type,
    ));
  }
}
