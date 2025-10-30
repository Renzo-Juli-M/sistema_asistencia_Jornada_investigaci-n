import 'package:equatable/equatable.dart';

abstract class JudgeAssignmentEvent extends Equatable {
  const JudgeAssignmentEvent();

  @override
  List<Object> get props => [];
}

class LoadAvailableJudgesEvent extends JudgeAssignmentEvent {
  final int articleId;

  const LoadAvailableJudgesEvent(this.articleId);

  @override
  List<Object> get props => [articleId];
}

class AssignJudgesEvent extends JudgeAssignmentEvent {
  final int articleId;
  final List<int> judgeIds;

  const AssignJudgesEvent({
    required this.articleId,
    required this.judgeIds,
  });

  @override
  List<Object> get props => [articleId, judgeIds];
}
