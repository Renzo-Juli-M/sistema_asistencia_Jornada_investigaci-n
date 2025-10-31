import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_evaluations.dart';
import 'evaluations_event.dart';
import 'evaluations_state.dart';

class EvaluationsBloc extends Bloc<EvaluationsEvent, EvaluationsState> {
  final GetEvaluations getEvaluations;

  EvaluationsBloc({required this.getEvaluations}) : super(EvaluationsInitial()) {
    on<LoadEvaluationsEvent>(_onLoadEvaluations);
  }

  Future<void> _onLoadEvaluations(
    LoadEvaluationsEvent event,
    Emitter<EvaluationsState> emit,
  ) async {
    emit(EvaluationsLoading());

    final params = <String, dynamic>{
      if (event.status != null) 'status': event.status,
      if (event.articleId != null) 'article_id': event.articleId,
    };

    final result = await getEvaluations(params);

    result.fold(
      (failure) => emit(EvaluationsError(failure.message)),
      (data) {
        final evaluations = (data['evaluations'] as List?)
            ?.cast<Map<String, dynamic>>() ?? [];

        // Calculate summary
        int total = evaluations.length;
        int completed = 0;
        int pending = 0;

        for (var eval in evaluations) {
          final status = eval['assignment']?['status'] ?? 'pending';
          if (status == 'completed') {
            completed++;
          } else {
            pending++;
          }
        }

        final summary = {
          'total': total,
          'completed': completed,
          'pending': pending,
        };

        emit(EvaluationsLoaded(
          evaluations: evaluations,
          summary: summary,
        ));
      },
    );
  }
}
