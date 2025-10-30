import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/judge_assignment/judge_assignment_bloc.dart';
import '../bloc/judge_assignment/judge_assignment_event.dart';
import '../bloc/judge_assignment/judge_assignment_state.dart';

class JudgeAssignmentPage extends StatefulWidget {
  final int articleId;

  const JudgeAssignmentPage({super.key, required this.articleId});

  @override
  State<JudgeAssignmentPage> createState() => _JudgeAssignmentPageState();
}

class _JudgeAssignmentPageState extends State<JudgeAssignmentPage> {
  final Set<int> _selectedJudges = {};

  @override
  void initState() {
    super.initState();
    context.read<JudgeAssignmentBloc>().add(
          LoadAvailableJudgesEvent(widget.articleId),
        );
  }

  void _assignJudges() {
    if (_selectedJudges.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar al menos 2 jurados'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<JudgeAssignmentBloc>().add(
          AssignJudgesEvent(
            articleId: widget.articleId,
            judgeIds: _selectedJudges.toList(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar Jurados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _assignJudges,
            tooltip: 'Asignar seleccionados',
          ),
        ],
      ),
      body: BlocConsumer<JudgeAssignmentBloc, JudgeAssignmentState>(
        listener: (context, state) {
          if (state is JudgeAssignmentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }

          if (state is JudgeAssignmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is JudgeAssignmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is JudgeAssignmentError) {
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
                      context.read<JudgeAssignmentBloc>().add(
                            LoadAvailableJudgesEvent(widget.articleId),
                          );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is JudgeAssignmentLoaded) {
            if (state.availableJudges.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No hay jurados disponibles',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Todos los jurados ya están asignados',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Selection Info
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Seleccionados: ${_selectedJudges.length}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      if (_selectedJudges.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedJudges.clear();
                            });
                          },
                          child: const Text('Limpiar'),
                        ),
                    ],
                  ),
                ),

                // Info Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Debe seleccionar al menos 2 jurados por artículo',
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Judge List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.availableJudges.length,
                    itemBuilder: (context, index) {
                      final judge = state.availableJudges[index];
                      final judgeId = judge['id'] as int;
                      final isSelected = _selectedJudges.contains(judgeId);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: isSelected ? 4 : 1,
                        color: isSelected ? Colors.purple[50] : null,
                        child: CheckboxListTile(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedJudges.add(judgeId);
                              } else {
                                _selectedJudges.remove(judgeId);
                              }
                            });
                          },
                          title: Text(
                            judge['name'] as String,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (judge['email'] != null)
                                Text('Email: ${judge['email']}'),
                              if (judge['dni'] != null)
                                Text('DNI: ${judge['dni']}'),
                              if (judge['assigned_articles_count'] != null)
                                Text(
                                  'Artículos asignados: ${judge['assigned_articles_count']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                          secondary: CircleAvatar(
                            backgroundColor: isSelected ? Colors.purple : Colors.grey,
                            child: Text(
                              (judge['name'] as String)[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Action Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: ElevatedButton(
                      onPressed: _selectedJudges.length < 2
                          ? null
                          : (state is JudgeAssignmentAssigning ? null : _assignJudges),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: state is JudgeAssignmentAssigning
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Asignar ${_selectedJudges.length} Jurado${_selectedJudges.length != 1 ? 's' : ''}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
