import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Genere reportes detallados en formato Excel para análisis y registro',
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Reportes Disponibles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Students Report
            _ReportCard(
              title: 'Reporte de Estudiantes',
              description: 'Lista completa de estudiantes registrados con su información',
              icon: Icons.school,
              color: Colors.blue,
              onGenerate: () {
                _generateReport('students');
              },
            ),

            const SizedBox(height: 12),

            // Judges Report
            _ReportCard(
              title: 'Reporte de Jurados',
              description: 'Lista de jurados con sus asignaciones y evaluaciones realizadas',
              icon: Icons.gavel,
              color: Colors.purple,
              onGenerate: () {
                _generateReport('judges');
              },
            ),

            const SizedBox(height: 12),

            // Articles Report
            _ReportCard(
              title: 'Reporte de Artículos',
              description: 'Artículos con sus calificaciones y estado de evaluación',
              icon: Icons.article,
              color: Colors.green,
              onGenerate: () {
                _generateReport('articles');
              },
            ),

            const SizedBox(height: 12),

            // Evaluations Report
            _ReportCard(
              title: 'Reporte de Evaluaciones',
              description: 'Detalle completo de todas las evaluaciones con criterios y puntajes',
              icon: Icons.assessment,
              color: Colors.orange,
              onGenerate: () {
                _generateReport('evaluations');
              },
            ),

            const SizedBox(height: 12),

            // Attendance Report
            _ReportCard(
              title: 'Reporte de Asistencias',
              description: 'Registro de asistencias de estudiantes y participantes',
              icon: Icons.check_circle,
              color: Colors.teal,
              onGenerate: () {
                _generateReport('attendances');
              },
            ),

            const SizedBox(height: 12),

            // Complete Report
            _ReportCard(
              title: 'Reporte Completo',
              description: 'Reporte general con todos los datos del sistema',
              icon: Icons.summarize,
              color: Colors.indigo,
              onGenerate: () {
                _generateReport('complete');
              },
            ),

            const SizedBox(height: 24),

            // Custom Report Section
            const Text(
              'Reporte Personalizado',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seleccione los datos a incluir:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      title: const Text('Estudiantes'),
                      value: _includeStudents,
                      onChanged: (value) {
                        setState(() => _includeStudents = value ?? false);
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Jurados'),
                      value: _includeJudges,
                      onChanged: (value) {
                        setState(() => _includeJudges = value ?? false);
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Artículos'),
                      value: _includeArticles,
                      onChanged: (value) {
                        setState(() => _includeArticles = value ?? false);
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Evaluaciones'),
                      value: _includeEvaluations,
                      onChanged: (value) {
                        setState(() => _includeEvaluations = value ?? false);
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Asistencias'),
                      value: _includeAttendances,
                      onChanged: (value) {
                        setState(() => _includeAttendances = value ?? false);
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _hasSelection()
                            ? () => _generateCustomReport()
                            : null,
                        icon: const Icon(Icons.download),
                        label: const Text('Generar Reporte Personalizado'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _includeStudents = false;
  bool _includeJudges = false;
  bool _includeArticles = false;
  bool _includeEvaluations = false;
  bool _includeAttendances = false;

  bool _hasSelection() {
    return _includeStudents ||
        _includeJudges ||
        _includeArticles ||
        _includeEvaluations ||
        _includeAttendances;
  }

  void _generateReport(String type) {
    // TODO: Implement report generation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generando reporte de $type...'),
        backgroundColor: Colors.green,
      ),
    );

    // In production, this would call an API endpoint like:
    // GET /api/admin/reports/{type}
    // The backend would generate an Excel file and return it
  }

  void _generateCustomReport() {
    final List<String> selected = [];
    if (_includeStudents) selected.add('students');
    if (_includeJudges) selected.add('judges');
    if (_includeArticles) selected.add('articles');
    if (_includeEvaluations) selected.add('evaluations');
    if (_includeAttendances) selected.add('attendances');

    // TODO: Implement custom report generation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generando reporte personalizado con: ${selected.join(", ")}'),
        backgroundColor: Colors.green,
      ),
    );

    // In production, this would call:
    // POST /api/admin/reports/custom
    // with body: { "include": selected }
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onGenerate;

  const _ReportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
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
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onGenerate,
                icon: const Icon(Icons.download),
                label: const Text('Generar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
