import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/di/injection.dart';
import '../bloc/qr_generator_bloc.dart';

class QRGeneratorPage extends StatefulWidget {
  final List<Map<String, dynamic>> articles;
  final int? preselectedArticleId;

  const QRGeneratorPage({
    Key? key,
    required this.articles,
    this.preselectedArticleId,
  }) : super(key: key);

  @override
  State<QRGeneratorPage> createState() => _QRGeneratorPageState();
}

class _QRGeneratorPageState extends State<QRGeneratorPage> {
  int? selectedArticleId;

  @override
  void initState() {
    super.initState();
    selectedArticleId = widget.preselectedArticleId ?? widget.articles.first['id'];
    
    // Check if QR already exists for preselected article
    if (selectedArticleId != null) {
      context.read<QRGeneratorBloc>().add(CheckExistingQREvent(selectedArticleId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar QR de Asistencia'),
      ),
      body: BlocListener<QRGeneratorBloc, QRGeneratorState>(
        listener: (context, state) {
          if (state is QRGeneratorError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Article selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selecciona tu artículo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: selectedArticleId,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Artículo',
                        ),
                        items: widget.articles.map((article) {
                          return DropdownMenuItem<int>(
                            value: article['id'],
                            child: Text(article['title'] ?? 'Sin título'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedArticleId = value;
                            });
                            context
                                .read<QRGeneratorBloc>()
                                .add(CheckExistingQREvent(value));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // QR Display
              BlocBuilder<QRGeneratorBloc, QRGeneratorState>(
                builder: (context, state) {
                  if (state is QRGeneratorLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is QRGeneratorLoaded) {
                    return Column(
                      children: [
                        // Warning if already generated
                        if (state.isExisting)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
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
                                    'Este QR ya fue generado previamente.',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // QR Code Display
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Text(
                                  state.qrData.articleTitle,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                QrImageView(
                                  data: state.qrData.qrCode,
                                  version: QrVersions.auto,
                                  size: 280.0,
                                  backgroundColor: Colors.white,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Generado: ${_formatDateTime(state.qrData.generatedAt)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (state.qrData.expiresAt != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Expira: ${_formatDateTime(state.qrData.expiresAt!)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: state.qrData.isExpired
                                          ? Colors.red
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Instructions
                        Card(
                          color: Colors.green[50],
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Icon(Icons.info_outline, color: Colors.green),
                                SizedBox(height: 8),
                                Text(
                                  'Instrucciones:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '1. Muestra este QR a los oyentes\n'
                                  '2. Los oyentes deben escanearlo para registrar su asistencia\n'
                                  '3. Este QR es único para tu artículo',
                                  style: TextStyle(color: Colors.green),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  // Initial state - show generate button
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Icon(Icons.qr_code, size: 80, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'Genera tu código QR de asistencia',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: selectedArticleId != null
                                ? () {
                                    context.read<QRGeneratorBloc>().add(
                                        GenerateQREvent(selectedArticleId!));
                                  }
                                : null,
                            icon: const Icon(Icons.qr_code),
                            label: const Text('Generar QR'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
