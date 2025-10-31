import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/attendance_history_bloc.dart';

class AttendanceHistoryPage extends StatelessWidget {
  const AttendanceHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AttendanceHistoryBloc>()..add(LoadAttendanceHistoryEvent()),
      child: const _AttendanceHistoryView(),
    );
  }
}

class _AttendanceHistoryView extends StatelessWidget {
  const _AttendanceHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Asistencias'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar',
            onSelected: (value) {
              if (value == 'all') {
                context
                    .read<AttendanceHistoryBloc>()
                    .add(const FilterByTypeEvent(null));
              } else {
                context
                    .read<AttendanceHistoryBloc>()
                    .add(FilterByTypeEvent(value));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('Todas'),
              ),
              const PopupMenuItem(
                value: 'ponente',
                child: Text('Como Ponente'),
              ),
              const PopupMenuItem(
                value: 'oyente',
                child: Text('Como Oyente'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<AttendanceHistoryBloc>()
                  .add(RefreshHistoryEvent());
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: BlocBuilder<AttendanceHistoryBloc, AttendanceHistoryState>(
        builder: (context, state) {
          if (state is AttendanceHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AttendanceHistoryError) {
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
                          .read<AttendanceHistoryBloc>()
                          .add(LoadAttendanceHistoryEvent());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is AttendanceHistoryLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<AttendanceHistoryBloc>()
                    .add(RefreshHistoryEvent());
              },
              child: Column(
                children: [
                  // Filter Info Banner
                  if (state.filterType != null)
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
                              'Mostrando: ${state.filterType == 'ponente' ? 'Como Ponente' : 'Como Oyente'}',
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                size: 20, color: Colors.blue),
                            onPressed: () {
                              context
                                  .read<AttendanceHistoryBloc>()
                                  .add(const FilterByTypeEvent(null));
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
                                  state.filterType != null
                                      ? 'No hay asistencias con este filtro'
                                      : 'No has registrado asistencias aún',
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
                              final attendance = state.filteredHistory[index];
                              return _buildAttendanceCard(attendance);
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

  Widget _buildAttendanceCard(attendance) {
    final isPonente = attendance.studentType == 'ponente';
    final color = isPonente ? Colors.blue : Colors.green;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPonente ? Icons.person : Icons.people,
                        size: 16,
                        color: color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isPonente ? 'Ponente' : 'Oyente',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (attendance.isConfirmed)
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              attendance.articleTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              attendance.categoryName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.event_available, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Registrado: ${_formatDateTime(attendance.registeredAt)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
