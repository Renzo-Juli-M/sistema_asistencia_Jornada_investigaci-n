import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/import_students.dart';
import '../../../domain/usecases/import_judges.dart';
import '../../../domain/usecases/import_articles.dart';
import 'import_event.dart';
import 'import_state.dart';

class ImportBloc extends Bloc<ImportEvent, ImportState> {
  final ImportStudents importStudents;
  final ImportJudges importJudges;
  final ImportArticles importArticles;

  ImportBloc({
    required this.importStudents,
    required this.importJudges,
    required this.importArticles,
  }) : super(ImportInitial()) {
    on<ImportFileEvent>(_onImportFile);
  }

  Future<void> _onImportFile(
    ImportFileEvent event,
    Emitter<ImportState> emit,
  ) async {
    emit(ImportLoading(event.type));

    try {
      // Create FormData with the file
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          event.filePath,
          filename: event.filePath.split('/').last,
        ),
      });

      // Call appropriate use case based on type
      final result = await _getImportUseCase(event.type)(formData);

      result.fold(
        (failure) => emit(ImportError(failure.message)),
        (_) {
          // Mock stats - in production, the backend should return these
          final stats = {
            'processed': 50,
            'imported': 45,
            'skipped': 5,
          };

          emit(ImportSuccess(
            _getSuccessMessage(event.type),
            stats: stats,
          ));
        },
      );
    } catch (e) {
      emit(ImportError('Error al importar: ${e.toString()}'));
    }
  }

  Function _getImportUseCase(String type) {
    switch (type) {
      case 'students':
        return importStudents;
      case 'judges':
        return importJudges;
      case 'articles':
        return importArticles;
      default:
        throw Exception('Tipo de importación no válido');
    }
  }

  String _getSuccessMessage(String type) {
    switch (type) {
      case 'students':
        return 'Estudiantes importados exitosamente';
      case 'judges':
        return 'Jurados importados exitosamente';
      case 'articles':
        return 'Artículos importados exitosamente';
      default:
        return 'Importación exitosa';
    }
  }
}
