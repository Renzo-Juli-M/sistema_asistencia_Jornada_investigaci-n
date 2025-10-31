import 'package:equatable/equatable.dart';

enum StudentType {
  ponente,
  oyente,
}

class StudentAttendance extends Equatable {
  final int id;
  final int userId;
  final int articleId;
  final String articleTitle;
  final String categoryName;
  final String studentType; // 'ponente' or 'oyente'
  final DateTime registeredAt;
  final String? qrCode;
  final bool isConfirmed;

  const StudentAttendance({
    required this.id,
    required this.userId,
    required this.articleId,
    required this.articleTitle,
    required this.categoryName,
    required this.studentType,
    required this.registeredAt,
    this.qrCode,
    required this.isConfirmed,
  });

  bool get isPonente => studentType == 'ponente';
  bool get isOyente => studentType == 'oyente';

  @override
  List<Object?> get props => [
        id,
        userId,
        articleId,
        articleTitle,
        categoryName,
        studentType,
        registeredAt,
        qrCode,
        isConfirmed,
      ];
}

class QRData extends Equatable {
  final String qrCode;
  final int articleId;
  final String articleTitle;
  final DateTime generatedAt;
  final DateTime? expiresAt;

  const QRData({
    required this.qrCode,
    required this.articleId,
    required this.articleTitle,
    required this.generatedAt,
    this.expiresAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  @override
  List<Object?> get props => [
        qrCode,
        articleId,
        articleTitle,
        generatedAt,
        expiresAt,
      ];
}

class StudentStats extends Equatable {
  final int totalAttendances;
  final int ponenteCount;
  final int oyenteCount;
  final List<String> categoriesAttended;
  final DateTime? lastAttendance;
  final int articlesPresented;

  const StudentStats({
    required this.totalAttendances,
    required this.ponenteCount,
    required this.oyenteCount,
    required this.categoriesAttended,
    this.lastAttendance,
    required this.articlesPresented,
  });

  @override
  List<Object?> get props => [
        totalAttendances,
        ponenteCount,
        oyenteCount,
        categoriesAttended,
        lastAttendance,
        articlesPresented,
      ];
}

class AttendanceConfirmation extends Equatable {
  final bool success;
  final String message;
  final StudentAttendance? attendance;

  const AttendanceConfirmation({
    required this.success,
    required this.message,
    this.attendance,
  });

  @override
  List<Object?> get props => [success, message, attendance];
}
