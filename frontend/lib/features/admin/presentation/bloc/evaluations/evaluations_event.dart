import 'package:equatable/equatable.dart';

abstract class EvaluationsEvent extends Equatable {
  const EvaluationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvaluationsEvent extends EvaluationsEvent {
  final String? status;
  final int? articleId;

  const LoadEvaluationsEvent({
    this.status,
    this.articleId,
  });

  @override
  List<Object?> get props => [status, articleId];
}
