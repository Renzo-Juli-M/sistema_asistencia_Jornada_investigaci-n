import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/judge_evaluation_bloc.dart';

class JudgeEvaluationFormPage extends StatelessWidget {
  final int assignmentId;

  const JudgeEvaluationFormPage({
    Key? key,
    required this.assignmentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<JudgeEvaluationBloc>()
        ..add(LoadEvaluationFormEvent(assignmentId)),
      child: _JudgeEvaluationFormView(assignmentId: assignmentId),
    );
  }
}

class _JudgeEvaluationFormView extends StatelessWidget {
  final int assignmentId;

  const _JudgeEvaluationFormView({required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluación de Artículo'),
      ),
      body: BlocConsumer<JudgeEvaluationBloc, JudgeEvaluationState>(
        listener: (context, state) {
          if (state is JudgeEvaluationSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
            // Return to dashboard after successful submission
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                Navigator.pop(context);
              }
            });
          }

          if (state is JudgeEvaluationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is JudgeEvaluationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is JudgeEvaluationError &&
              state != context.watch<JudgeEvaluationBloc>().state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is JudgeEvaluationFormReady ||
              state is JudgeEvaluationSubmitting) {
            final formState = state is JudgeEvaluationFormReady
                ? state
                : (state as JudgeEvaluationSubmitting);
            final assignment = formState is JudgeEvaluationFormReady
                ? formState.assignment
                : (formState as JudgeEvaluationSubmitting).assignment;
            final criteria = formState is JudgeEvaluationFormReady
                ? formState.criteria
                : (formState as JudgeEvaluationSubmitting).criteria;
            final scores = formState is JudgeEvaluationFormReady
                ? formState.scores
                : (formState as JudgeEvaluationSubmitting).scores;
            final isReadOnly = formState is JudgeEvaluationFormReady
                ? formState.isReadOnly
                : false;
            final isSubmitting = state is JudgeEvaluationSubmitting;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Info Card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment.articleTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.category,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                assignment.categoryName,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.person,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                assignment.authorName,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            assignment.articleDescription,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Read-only warning
                  if (isReadOnly)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Esta evaluación ya ha sido enviada y no puede modificarse.',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isReadOnly) const SizedBox(height: 24),

                  // Evaluation Criteria
                  const Text(
                    'Criterios de Evaluación',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...criteria.map((criterion) {
                    final score = scores[criterion.id];
                    return _buildCriterionCard(
                      context,
                      criterion,
                      score,
                      isReadOnly,
                      isSubmitting,
                    );
                  }),

                  const SizedBox(height: 24),

                  // Submit Button
                  if (!isReadOnly)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSubmitting ||
                                scores.length != criteria.length
                            ? null
                            : () {
                                _showConfirmationDialog(context);
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Enviar Evaluación',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCriterionCard(
    BuildContext context,
    criterion,
    int? score,
    bool isReadOnly,
    bool isSubmitting,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    criterion.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Peso: ${criterion.weight}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (criterion.description != null) ...[
              const SizedBox(height: 8),
              Text(
                criterion.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Puntuación:',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Slider(
                    value: (score ?? 0).toDouble(),
                    min: 0,
                    max: criterion.maxScore.toDouble(),
                    divisions: criterion.maxScore,
                    label: score?.toString() ?? '0',
                    onChanged: isReadOnly || isSubmitting
                        ? null
                        : (value) {
                            context.read<JudgeEvaluationBloc>().add(
                                  UpdateScoreEvent(
                                    criteriaId: criterion.id,
                                    score: value.toInt(),
                                  ),
                                );
                          },
                  ),
                ),
                Container(
                  width: 60,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: score != null && score > 0
                        ? Colors.green[50]
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${score ?? 0} / ${criterion.maxScore}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: score != null && score > 0
                          ? Colors.green[700]
                          : Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar Evaluación'),
        content: const Text(
          'Una vez enviada, la evaluación no podrá ser modificada. ¿Desea continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<JudgeEvaluationBloc>()
                  .add(SubmitEvaluationEvent(assignmentId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
