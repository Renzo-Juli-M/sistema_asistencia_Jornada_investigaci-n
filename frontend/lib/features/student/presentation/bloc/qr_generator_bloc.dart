import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/student_attendance.dart';
import '../../domain/usecases/generate_attendance_qr.dart';
import '../../domain/usecases/get_existing_qr.dart';

// Events
abstract class QRGeneratorEvent extends Equatable {
  const QRGeneratorEvent();

  @override
  List<Object?> get props => [];
}

class GenerateQREvent extends QRGeneratorEvent {
  final int articleId;

  const GenerateQREvent(this.articleId);

  @override
  List<Object?> get props => [articleId];
}

class CheckExistingQREvent extends QRGeneratorEvent {
  final int articleId;

  const CheckExistingQREvent(this.articleId);

  @override
  List<Object?> get props => [articleId];
}

// States
abstract class QRGeneratorState extends Equatable {
  const QRGeneratorState();

  @override
  List<Object?> get props => [];
}

class QRGeneratorInitial extends QRGeneratorState {}

class QRGeneratorLoading extends QRGeneratorState {}

class QRGeneratorLoaded extends QRGeneratorState {
  final QRData qrData;
  final bool isExisting;

  const QRGeneratorLoaded({
    required this.qrData,
    required this.isExisting,
  });

  @override
  List<Object?> get props => [qrData, isExisting];
}

class QRGeneratorError extends QRGeneratorState {
  final String message;

  const QRGeneratorError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class QRGeneratorBloc extends Bloc<QRGeneratorEvent, QRGeneratorState> {
  final GenerateAttendanceQR generateAttendanceQR;
  final GetExistingQR getExistingQR;

  QRGeneratorBloc({
    required this.generateAttendanceQR,
    required this.getExistingQR,
  }) : super(QRGeneratorInitial()) {
    on<GenerateQREvent>(_onGenerateQR);
    on<CheckExistingQREvent>(_onCheckExistingQR);
  }

  Future<void> _onGenerateQR(
    GenerateQREvent event,
    Emitter<QRGeneratorState> emit,
  ) async {
    emit(QRGeneratorLoading());

    final result = await generateAttendanceQR(event.articleId);

    result.fold(
      (failure) => emit(QRGeneratorError(failure.message)),
      (qrData) => emit(QRGeneratorLoaded(
        qrData: qrData,
        isExisting: false,
      )),
    );
  }

  Future<void> _onCheckExistingQR(
    CheckExistingQREvent event,
    Emitter<QRGeneratorState> emit,
  ) async {
    emit(QRGeneratorLoading());

    final result = await getExistingQR(event.articleId);

    result.fold(
      (failure) => emit(QRGeneratorError(failure.message)),
      (qrData) {
        if (qrData != null) {
          emit(QRGeneratorLoaded(
            qrData: qrData,
            isExisting: true,
          ));
        } else {
          // No existing QR, generate a new one
          add(GenerateQREvent(event.articleId));
        }
      },
    );
  }
}
