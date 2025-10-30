import 'package:equatable/equatable.dart';

abstract class JudgeAssignmentState extends Equatable {
  const JudgeAssignmentState();

  @override
  List<Object> get props => [];
}

class JudgeAssignmentInitial extends JudgeAssignmentState {}

class JudgeAssignmentLoading extends JudgeAssignmentState {}

class JudgeAssignmentLoaded extends JudgeAssignmentState {
  final List<Map<String, dynamic>> availableJudges;

  const JudgeAssignmentLoaded(this.availableJudges);

  @override
  List<Object> get props => [availableJudges];
}

class JudgeAssignmentAssigning extends JudgeAssignmentState {}

class JudgeAssignmentSuccess extends JudgeAssignmentState {
  final String message;

  const JudgeAssignmentSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class JudgeAssignmentError extends JudgeAssignmentState {
  final String message;

  const JudgeAssignmentError(this.message);

  @override
  List<Object> get props => [message];
}
