import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/category_model.dart';
import '../bloc/article_form/article_form_bloc.dart';
import '../bloc/article_form/article_form_event.dart';
import '../bloc/article_form/article_form_state.dart';

class ArticleFormPage extends StatefulWidget {
  final int? articleId; // null = create, not null = edit

  const ArticleFormPage({super.key, this.articleId});

  @override
  State<ArticleFormPage> createState() => _ArticleFormPageState();
}

class _ArticleFormPageState extends State<ArticleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _abstractController = TextEditingController();
  final _keywordsController = TextEditingController();

  int? _selectedCategoryId;
  int? _selectedUserId;
  String _selectedStatus = 'draft';

  @override
  void initState() {
    super.initState();
    context.read<ArticleFormBloc>().add(LoadFormDataEvent());

    if (widget.articleId != null) {
      context.read<ArticleFormBloc>().add(LoadArticleEvent(widget.articleId!));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _abstractController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'title': _titleController.text,
        'description': _descriptionController.text.isEmpty ? null : _descriptionController.text,
        'abstract': _abstractController.text.isEmpty ? null : _abstractController.text,
        'keywords': _keywordsController.text.isEmpty ? null : _keywordsController.text,
        'category_id': _selectedCategoryId,
        'user_id': _selectedUserId,
        'status': _selectedStatus,
      };

      if (widget.articleId == null) {
        context.read<ArticleFormBloc>().add(CreateArticleEvent(data));
      } else {
        context.read<ArticleFormBloc>().add(UpdateArticleEvent(widget.articleId!, data));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.articleId == null ? 'Crear Artículo' : 'Editar Artículo'),
      ),
      body: BlocConsumer<ArticleFormBloc, ArticleFormState>(
        listener: (context, state) {
          if (state is ArticleFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }

          if (state is ArticleFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is ArticleFormLoaded && widget.articleId != null) {
            _titleController.text = state.article?.title ?? '';
            _descriptionController.text = state.article?.description ?? '';
            _abstractController.text = state.article?.abstract ?? '';
            _keywordsController.text = state.article?.keywords ?? '';
            _selectedCategoryId = state.article?.categoryId;
            _selectedUserId = state.article?.userId;
            _selectedStatus = state.article?.status ?? 'draft';
          }
        },
        builder: (context, state) {
          if (state is ArticleFormLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ArticleFormLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El título es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _abstractController,
                      decoration: const InputDecoration(
                        labelText: 'Resumen',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _keywordsController,
                      decoration: const InputDecoration(
                        labelText: 'Palabras Clave',
                        hintText: 'Separadas por comas',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Sin categoría')),
                        ...state.categories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedCategoryId = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedUserId,
                      decoration: const InputDecoration(
                        labelText: 'Autor (Estudiante) *',
                        border: OutlineInputBorder(),
                      ),
                      items: state.students.map((student) {
                        return DropdownMenuItem(
                          value: student['id'],
                          child: Text(student['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedUserId = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'El autor es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Estado *',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'draft', child: Text('Borrador')),
                        DropdownMenuItem(value: 'submitted', child: Text('Enviado')),
                        DropdownMenuItem(value: 'under_review', child: Text('En Revisión')),
                        DropdownMenuItem(value: 'approved', child: Text('Aprobado')),
                        DropdownMenuItem(value: 'rejected', child: Text('Rechazado')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedStatus = value!);
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: state is ArticleFormSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state is ArticleFormSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(widget.articleId == null ? 'Crear Artículo' : 'Guardar Cambios'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
