import 'package:injectable/injectable.dart';
import '../../domain/usecases/generate_attendance_qr.dart';
import '../../domain/usecases/get_existing_qr.dart';
import '../../domain/usecases/get_my_articles.dart';
import '../../domain/usecases/get_my_attendance_history.dart';
import '../../domain/usecases/get_my_stats.dart';
import '../../domain/usecases/scan_and_register_attendance.dart';
import 'attendance_history_bloc.dart';
import 'qr_generator_bloc.dart';
import 'qr_scanner_bloc.dart';
import 'student_dashboard_bloc.dart';
import 'student_stats_bloc.dart';

@module
abstract class StudentBlocModule {
  @injectable
  StudentDashboardBloc studentDashboardBloc(
    GetMyArticles getMyArticles,
    GetMyStats getMyStats,
  ) =>
      StudentDashboardBloc(
        getMyArticles: getMyArticles,
        getMyStats: getMyStats,
      );

  @injectable
  QRGeneratorBloc qrGeneratorBloc(
    GenerateAttendanceQR generateAttendanceQR,
    GetExistingQR getExistingQR,
  ) =>
      QRGeneratorBloc(
        generateAttendanceQR: generateAttendanceQR,
        getExistingQR: getExistingQR,
      );

  @injectable
  QRScannerBloc qrScannerBloc(
    ScanAndRegisterAttendance scanAndRegisterAttendance,
  ) =>
      QRScannerBloc(
        scanAndRegisterAttendance: scanAndRegisterAttendance,
      );

  @injectable
  AttendanceHistoryBloc attendanceHistoryBloc(
    GetMyAttendanceHistory getMyAttendanceHistory,
  ) =>
      AttendanceHistoryBloc(
        getMyAttendanceHistory: getMyAttendanceHistory,
      );

  @injectable
  StudentStatsBloc studentStatsBloc(GetMyStats getMyStats) =>
      StudentStatsBloc(getMyStats: getMyStats);
}
