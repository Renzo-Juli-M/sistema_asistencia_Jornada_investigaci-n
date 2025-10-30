import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/import/import_bloc.dart';
import '../bloc/import/import_event.dart';
import '../bloc/import/import_state.dart';

class ImportDataPage extends StatefulWidget {
  const ImportDataPage({super.key});

  @override
  State<ImportDataPage> createState() => _ImportDataPageState();
}

class _ImportDataPageState extends State<ImportDataPage> {
  String? _selectedStudentsFile;
  String? _selectedJudgesFile;
  String? _selectedArticlesFile;

  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      setState(() {
        switch (type) {
          case 'students':
            _selectedStudentsFile = result.files.single.name;
            break;
          case 'judges':
            _selectedJudgesFile = result.files.single.name;
            break;
          case 'articles':
            _selectedArticlesFile = result.files.single.name;
            break;
        }
      });

      // Import the file
      context.read<ImportBloc>().add(
            ImportFileEvent(
              type: type,
              filePath: result.files.single.path!,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Datos'),
      ),
      body: BlocConsumer<ImportBloc, ImportState>(
        listener: (context, state) {
          if (state is ImportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }

          if (state is ImportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructions Card
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            Text(
                              'Instrucciones',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '• Los archivos deben estar en formato Excel (.xlsx o .xls)\n'
                          '• Asegúrese de que las columnas coincidan con el formato requerido\n'
                          '• Los registros duplicados serán omitidos automáticamente\n'
                          '• Descargue las plantillas de ejemplo si es necesario',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Students Import
                _ImportCard(
                  title: 'Importar Estudiantes',
                  description: 'Importe una lista de estudiantes desde un archivo Excel',
                  icon: Icons.school,
                  color: Colors.blue,
                  selectedFile: _selectedStudentsFile,
                  isLoading: state is ImportLoading && state.type == 'students',
                  onPickFile: () => _pickFile('students'),
                  onDownloadTemplate: () {
                    // TODO: Implement template download
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Descargando plantilla...')),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Judges Import
                _ImportCard(
                  title: 'Importar Jurados',
                  description: 'Importe una lista de jurados desde un archivo Excel',
                  icon: Icons.gavel,
                  color: Colors.purple,
                  selectedFile: _selectedJudgesFile,
                  isLoading: state is ImportLoading && state.type == 'judges',
                  onPickFile: () => _pickFile('judges'),
                  onDownloadTemplate: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Descargando plantilla...')),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Articles Import
                _ImportCard(
                  title: 'Importar Artículos',
                  description: 'Importe una lista de artículos desde un archivo Excel',
                  icon: Icons.article,
                  color: Colors.green,
                  selectedFile: _selectedArticlesFile,
                  isLoading: state is ImportLoading && state.type == 'articles',
                  onPickFile: () => _pickFile('articles'),
                  onDownloadTemplate: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Descargando plantilla...')),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Import History (if available)
                if (state is ImportSuccess && state.stats != null) ...[
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Último Resultado',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StatRow(
                            label: 'Registros procesados',
                            value: state.stats!['processed'].toString(),
                            icon: Icons.list_alt,
                            color: Colors.blue,
                          ),
                          const Divider(),
                          _StatRow(
                            label: 'Importados exitosamente',
                            value: state.stats!['imported'].toString(),
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                          const Divider(),
                          _StatRow(
                            label: 'Omitidos (duplicados)',
                            value: state.stats!['skipped'].toString(),
                            icon: Icons.skip_next,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ImportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? selectedFile;
  final bool isLoading;
  final VoidCallback onPickFile;
  final VoidCallback onDownloadTemplate;

  const _ImportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.selectedFile,
    required this.isLoading,
    required this.onPickFile,
    required this.onDownloadTemplate,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (selectedFile != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.file_present, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedFile!,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : onPickFile,
                    icon: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload_file),
                    label: Text(isLoading ? 'Importando...' : 'Seleccionar Archivo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: onDownloadTemplate,
                  icon: const Icon(Icons.download),
                  tooltip: 'Descargar Plantilla',
                  style: IconButton.styleFrom(
                    backgroundColor: color.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
