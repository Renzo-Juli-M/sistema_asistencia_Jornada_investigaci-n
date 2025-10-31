import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/student_dashboard_bloc.dart';
import 'qr_generator_page.dart';
import 'qr_scanner_page.dart';
import 'attendance_history_page.dart';
import 'student_stats_page.dart';

class StudentDashboardPage extends StatelessWidget {
  const StudentDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Alumno'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttendanceHistoryPage(),
                ),
              );
            },
            tooltip: 'Historial',
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentStatsPage(),
                ),
              );
            },
            tooltip: 'Estadísticas',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<StudentDashboardBloc>()
                  .add(RefreshDashboardEvent());
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: BlocBuilder<StudentDashboardBloc, StudentDashboardState>(
        builder: (context, state) {
          if (state is StudentDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StudentDashboardError) {
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
                          .read<StudentDashboardBloc>()
                          .add(LoadStudentDashboardEvent());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is StudentDashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<StudentDashboardBloc>()
                    .add(RefreshDashboardEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Summary Cards
                    _buildStatsSummary(state.stats),
                    const SizedBox(height: 32),

                    // Main Actions
                    const Text(
                      '¿Qué deseas hacer?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Ponente Option
                    _buildActionCard(
                      context,
                      title: 'Generar QR de Asistencia',
                      subtitle: 'Soy ponente y quiero generar mi QR',
                      icon: Icons.qr_code,
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRGeneratorPage(
                              articles: state.myArticles,
                            ),
                          ),
                        ).then((_) {
                          // Refresh when returning
                          context
                              .read<StudentDashboardBloc>()
                              .add(RefreshDashboardEvent());
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Oyente Option
                    _buildActionCard(
                      context,
                      title: 'Escanear QR',
                      subtitle: 'Soy oyente y quiero registrar mi asistencia',
                      icon: Icons.qr_code_scanner,
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QRScannerPage(),
                          ),
                        ).then((_) {
                          // Refresh when returning
                          context
                              .read<StudentDashboardBloc>()
                              .add(RefreshDashboardEvent());
                        });
                      },
                    ),
                    const SizedBox(height: 32),

                    // My Articles Section (for ponentes)
                    if (state.myArticles.isNotEmpty) ...[
                      const Text(
                        'Mis Artículos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...state.myArticles.map((article) {
                        return _buildArticleCard(context, article);
                      }),
                    ],
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

  Widget _buildStatsSummary(stats) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen de Asistencias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total',
                    stats.totalAttendances.toString(),
                    Icons.event_available,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Ponente',
                    stats.ponenteCount.toString(),
                    Icons.person,
                    Colors.purple,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Oyente',
                    stats.oyenteCount.toString(),
                    Icons.people,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, Map<String, dynamic> article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to QR generator for this specific article
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRGeneratorPage(
                articles: [article],
                preselectedArticleId: article['id'],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['title'] ?? 'Sin título',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article['category']?['name'] ?? 'Sin categoría',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.qr_code, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
