import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/judge_history_bloc.dart';
import 'judge_evaluation_form_page.dart';

class JudgeHistoryPage extends StatelessWidget {
  const JudgeHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<JudgeHistoryBloc>()..add(LoadJudgeHistoryEvent()),
      child: const _JudgeHistoryView(),
    );
  }
}

class _JudgeHistoryView extends StatelessWidget {
  const _JudgeHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Evaluaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filtrar',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<JudgeHistoryBloc>().add(RefreshJudgeHistoryEvent());
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: BlocBuilder<JudgeHistoryBloc, JudgeHistoryState>(
        builder: (context, state) {
          if (state is JudgeHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is JudgeHistoryError) {
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<JudgeHistoryBloc>()
                          .add(LoadJudgeHistoryEvent());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is JudgeHistoryLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<JudgeHistoryBloc>().add(RefreshJudgeHistoryEvent());
              },
              child: Column(
                children: [
                  // Filter Info Banner
                  if (state.filterStartDate != null ||
                      state.filterEndDate != null)
                    Container(
                      color: Colors.blue[50],
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_list,
                              size: 20, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _buildFilterText(state),
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                size: 20, color: Colors.blue),
                            onPressed: () {
                              context.read<JudgeHistoryBloc>().add(
                                    const FilterHistoryByDateEvent(),
                                  );
                            },
                            tooltip: 'Limpiar filtro',
                          ),
                        ],
                      ),
                    ),

                  // History List
                  Expanded(
                    child: state.filteredHistory.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.history,
                                    size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  state.filterStartDate != null ||
                                          state.filterEndDate != null
                                      ? 'No hay evaluaciones en el rango seleccionado'
                                      : 'No has completado evaluaciones aún',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount: state.filteredHistory.length,
                            itemBuilder: (context, index) {
                              final assignment = state.filteredHistory[index];
                              return _buildHistoryCard(context, assignment);
                            },
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

  Widget _buildHistoryCard(BuildContext context, assignment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to evaluation form in read-only mode
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JudgeEvaluationFormPage(
                assignmentId: assignment.id,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      assignment.articleTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (assignment.averageScore != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getScoreColor(assignment.averageScore!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            assignment.averageScore!.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.category, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    assignment.categoryName,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    assignment.authorName,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                assignment.articleDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.event_available,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Completado: ${_formatDate(assignment.completedAt)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8.0) return Colors.green;
    if (score >= 6.0) return Colors.blue;
    if (score >= 4.0) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _buildFilterText(JudgeHistoryLoaded state) {
    if (state.filterStartDate != null && state.filterEndDate != null) {
      return 'Mostrando del ${_formatDate(state.filterStartDate)} al ${_formatDate(state.filterEndDate)}';
    } else if (state.filterStartDate != null) {
      return 'Mostrando desde ${_formatDate(state.filterStartDate)}';
    } else if (state.filterEndDate != null) {
      return 'Mostrando hasta ${_formatDate(state.filterEndDate)}';
    }
    return '';
  }

  void _showFilterDialog(BuildContext context) {
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filtrar por Fecha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.date_range),
                title: Text(
                  startDate == null
                      ? 'Fecha de Inicio'
                      : 'Inicio: ${_formatDate(startDate)}',
                ),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => startDate = date);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: Text(
                  endDate == null
                      ? 'Fecha de Fin'
                      : 'Fin: ${_formatDate(endDate)}',
                ),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => endDate = date);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context
                    .read<JudgeHistoryBloc>()
                    .add(const FilterHistoryByDateEvent());
              },
              child: const Text('Limpiar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<JudgeHistoryBloc>().add(
                      FilterHistoryByDateEvent(
                        startDate: startDate,
                        endDate: endDate,
                      ),
                    );
              },
              child: const Text('Aplicar'),
            ),
          ],
        ),
      ),
    );
  }
}
