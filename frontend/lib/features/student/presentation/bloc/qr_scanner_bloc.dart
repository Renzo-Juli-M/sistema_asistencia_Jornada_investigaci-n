import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/student_attendance.dart';
import '../../domain/usecases/scan_and_register_attendance.dart';

// Events
abstract class QRScannerEvent extends Equatable {
  const QRScannerEvent();

  @override
  List<Object?> get props => [];
}

class ScanQREvent extends QRScannerEvent {
  final String qrCode;

  const ScanQREvent(this.qrCode);

  @override
  List<Object?> get props => [qrCode];
}

class ResetScannerEvent extends QRScannerEvent {}

// States
abstract class QRScannerState extends Equatable {
  const QRScannerState();

  @override
  List<Object?> get props => [];
}

class QRScannerInitial extends QRScannerState {}

class QRScannerScanning extends QRScannerState {}

class QRScannerSuccess extends QRScannerState {
  final AttendanceConfirmation confirmation;

  const QRScannerSuccess(this.confirmation);

  @override
  List<Object?> get props => [confirmation];
}

class QRScannerError extends QRScannerState {
  final String message;

  const QRScannerError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class QRScannerBloc extends Bloc<QRScannerEvent, QRScannerState> {
  final ScanAndRegisterAttendance scanAndRegisterAttendance;

  QRScannerBloc({
    required this.scanAndRegisterAttendance,
  }) : super(QRScannerInitial()) {
    on<ScanQREvent>(_onScanQR);
    on<ResetScannerEvent>(_onResetScanner);
  }

  Future<void> _onScanQR(
    ScanQREvent event,
    Emitter<QRScannerState> emit,
  ) async {
    emit(QRScannerScanning());

    final result = await scanAndRegisterAttendance(event.qrCode);

    result.fold(
      (failure) => emit(QRScannerError(failure.message)),
      (confirmation) {
        if (confirmation.success) {
          emit(QRScannerSuccess(confirmation));
        } else {
          emit(QRScannerError(confirmation.message));
        }
      },
    );
  }

  void _onResetScanner(
    ResetScannerEvent event,
    Emitter<QRScannerState> emit,
  ) {
    emit(QRScannerInitial());
  }
}
