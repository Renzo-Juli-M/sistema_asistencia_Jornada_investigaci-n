import 'package:equatable/equatable.dart';

abstract class ImportState extends Equatable {
  const ImportState();

  @override
  List<Object?> get props => [];
}

class ImportInitial extends ImportState {}

class ImportLoading extends ImportState {
  final String type;

  const ImportLoading(this.type);

  @override
  List<Object> get props => [type];
}

class ImportSuccess extends ImportState {
  final String message;
  final Map<String, dynamic>? stats;

  const ImportSuccess(this.message, {this.stats});

  @override
  List<Object?> get props => [message, stats];
}

class ImportError extends ImportState {
  final String message;

  const ImportError(this.message);

  @override
  List<Object> get props => [message];
}
