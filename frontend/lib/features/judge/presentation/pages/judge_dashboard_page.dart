import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/judge_dashboard_bloc.dart';
import 'judge_evaluation_form_page.dart';
import 'judge_stats_page.dart';
import 'judge_history_page.dart';

class JudgeDashboardPage extends StatelessWidget {
  const JudgeDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Jurado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JudgeStatsPage(),
                ),
              );
            },
            tooltip: 'Estadísticas',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JudgeHistoryPage(),
                ),
              );
            },
            tooltip: 'Historial',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<JudgeDashboardBloc>()
                  .add(RefreshAssignmentsEvent());
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: BlocBuilder<JudgeDashboardBloc, JudgeDashboardState>(
        builder: (context, state) {
          if (state is JudgeDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is JudgeDashboardError) {
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
                          .read<JudgeDashboardBloc>()
                          .add(LoadMyAssignmentsEvent());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is JudgeDashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<JudgeDashboardBloc>()
                    .add(RefreshAssignmentsEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(context, state),
                    const SizedBox(height: 24),
                    if (state.pendingAssignments.isNotEmpty) ...[
                      const Text(
                        'Asignaciones Pendientes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...state.pendingAssignments.map(
                        (assignment) =>
                            _buildAssignmentCard(context, assignment, Colors.orange),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (state.inProgressAssignments.isNotEmpty) ...[
                      const Text(
                        'En Progreso',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...state.inProgressAssignments.map(
                        (assignment) =>
                            _buildAssignmentCard(context, assignment, Colors.blue),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (state.completedAssignments.isNotEmpty) ...[
                      const Text(
                        'Completadas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...state.completedAssignments.map(
                        (assignment) =>
                            _buildAssignmentCard(context, assignment, Colors.green),
                      ),
                    ],
                    if (state.assignments.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'No tienes asignaciones en este momento',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, JudgeDashboardLoaded state) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Pendientes',
            state.pendingAssignments.length.toString(),
            Colors.orange,
            Icons.pending_actions,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'En Progreso',
            state.inProgressAssignments.length.toString(),
            Colors.blue,
            Icons.edit_note,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Completadas',
            state.completedAssignments.length.toString(),
            Colors.green,
            Icons.check_circle,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String label, String count, Color color, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(
      BuildContext context, assignment, Color statusColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JudgeEvaluationFormPage(
                assignmentId: assignment.id,
              ),
            ),
          ).then((_) {
            // Refresh when returning from evaluation
            context.read<JudgeDashboardBloc>().add(RefreshAssignmentsEvent());
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: statusColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignment.articleTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          assignment.categoryName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (assignment.hasEvaluations)
                    const Icon(Icons.check_circle, color: Colors.green),
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
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    assignment.authorName,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(assignment.assignedAt),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              if (assignment.averageScore != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Calificación: ${assignment.averageScore!.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
