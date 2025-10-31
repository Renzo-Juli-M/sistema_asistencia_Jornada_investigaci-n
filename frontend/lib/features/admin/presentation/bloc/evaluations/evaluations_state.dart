import 'package:equatable/equatable.dart';

abstract class EvaluationsState extends Equatable {
  const EvaluationsState();

  @override
  List<Object> get props => [];
}

class EvaluationsInitial extends EvaluationsState {}

class EvaluationsLoading extends EvaluationsState {}

class EvaluationsLoaded extends EvaluationsState {
  final List<Map<String, dynamic>> evaluations;
  final Map<String, int> summary;

  const EvaluationsLoaded({
    required this.evaluations,
    required this.summary,
  });

  @override
  List<Object> get props => [evaluations, summary];
}

class EvaluationsError extends EvaluationsState {
  final String message;

  const EvaluationsError(this.message);

  @override
  List<Object> get props => [message];
}
