import 'package:equatable/equatable.dart';

abstract class ImportEvent extends Equatable {
  const ImportEvent();

  @override
  List<Object> get props => [];
}

class ImportFileEvent extends ImportEvent {
  final String type; // 'students', 'judges', 'articles'
  final String filePath;

  const ImportFileEvent({
    required this.type,
    required this.filePath,
  });

  @override
  List<Object> get props => [type, filePath];
}
