import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_event.dart';
import '../bloc/dashboard/dashboard_state.dart';
import '../widgets/stat_card.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardBloc>().add(RefreshDashboardEvent());
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<DashboardBloc>().add(LoadDashboardEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(RefreshDashboardEvent());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Statistics Grid
                    const Text(
                      'Estadísticas Generales',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        StatCard(
                          title: 'Estudiantes',
                          value: state.stats.totalStudents.toString(),
                          icon: Icons.school,
                          color: Colors.blue,
                          onTap: () {
                            Navigator.pushNamed(context, '/admin/students');
                          },
                        ),
                        StatCard(
                          title: 'Jurados',
                          value: state.stats.totalJudges.toString(),
                          icon: Icons.gavel,
                          color: Colors.purple,
                          onTap: () {
                            Navigator.pushNamed(context, '/admin/judges');
                          },
                        ),
                        StatCard(
                          title: 'Artículos',
                          value: state.stats.totalArticles.toString(),
                          icon: Icons.article,
                          color: Colors.green,
                          onTap: () {
                            Navigator.pushNamed(context, '/admin/articles');
                          },
                        ),
                        StatCard(
                          title: 'Asistencias',
                          value: state.stats.totalAttendances.toString(),
                          icon: Icons.check_circle,
                          color: Colors.orange,
                          onTap: () {
                            Navigator.pushNamed(context, '/admin/attendances');
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Student Types
                    const Text(
                      'Tipos de Estudiantes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'Ponentes',
                            value: state.stats.totalPonentes.toString(),
                            icon: Icons.mic,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatCard(
                            title: 'Oyentes',
                            value: state.stats.totalOyentes.toString(),
                            icon: Icons.hearing,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Articles by Status
                    const Text(
                      'Artículos por Estado',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: state.stats.articlesByStatus.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _getStatusLabel(entry.key),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(entry.key).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      entry.value.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _getStatusColor(entry.key),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Top Rated Articles
                    if (state.stats.topRatedArticles.isNotEmpty) ...[
                      const Text(
                        'Artículos Mejor Calificados',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.stats.topRatedArticles.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final article = state.stats.topRatedArticles[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                article.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text('Por: ${article.authorName}'),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star, size: 16, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(
                                      article.averageScore.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/admin/articles/${article.id}',
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Quick Actions
                    const Text(
                      'Acciones Rápidas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 2,
                      children: [
                        _QuickActionCard(
                          title: 'Importar Datos',
                          icon: Icons.upload_file,
                          color: Colors.blue,
                          onTap: () {
                            Navigator.pushNamed(context, '/admin/import');
                          },
                        ),
                        _QuickActionCard(
                          title: 'Asignar Jurados',
                          icon: Icons.assignment_ind,
                          color: Colors.purple,
                          onTap: () {
                            Navigator.pushNamed(context, '/admin/assignments');
                          },
                        ),
                        _QuickActionCard(
                          title: 'Ver Evaluaciones',
                          icon: Icons.assessment,
                          color: Colors.green,
                          onTap: () {
                            Navigator.pushNamed(context, '/admin/evaluations');
                          },
                        ),
                        _QuickActionCard(
                          title: 'Generar Reportes',
                          icon: Icons.bar_chart,
                          color: Colors.orange,
                          onTap: () {
                            Navigator.pushNamed(context, '/admin/reports');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Estado desconocido'));
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings, size: 40, color: Colors.blue),
                ),
                SizedBox(height: 12),
                Text(
                  'Administrador',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Estudiantes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/students');
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Jurados'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/judges');
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Artículos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/articles');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Importar Datos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/import');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_ind),
            title: const Text('Asignaciones'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/assignments');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Evaluaciones'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/evaluations');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Reportes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/reports');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              // TODO: Implement logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'draft':
        return 'Borrador';
      case 'submitted':
        return 'Enviado';
      case 'under_review':
        return 'En Revisión';
      case 'approved':
        return 'Aprobado';
      case 'rejected':
        return 'Rechazado';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'draft':
        return Colors.grey;
      case 'submitted':
        return Colors.blue;
      case 'under_review':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
