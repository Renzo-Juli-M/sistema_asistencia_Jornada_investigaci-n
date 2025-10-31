import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/student_attendance.dart';

part 'student_attendance_model.g.dart';

@JsonSerializable()
class StudentAttendanceModel {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'article_id')
  final int articleId;
  @JsonKey(name: 'article')
  final ArticleInfo? article;
  @JsonKey(name: 'student_type')
  final String studentType;
  @JsonKey(name: 'registered_at')
  final String registeredAt;
  @JsonKey(name: 'qr_code')
  final String? qrCode;
  @JsonKey(name: 'is_confirmed')
  final bool isConfirmed;

  StudentAttendanceModel({
    required this.id,
    required this.userId,
    required this.articleId,
    this.article,
    required this.studentType,
    required this.registeredAt,
    this.qrCode,
    required this.isConfirmed,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$StudentAttendanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentAttendanceModelToJson(this);

  StudentAttendance toEntity() {
    return StudentAttendance(
      id: id,
      userId: userId,
      articleId: articleId,
      articleTitle: article?.title ?? 'Sin título',
      categoryName: article?.category?.name ?? 'Sin categoría',
      studentType: studentType,
      registeredAt: DateTime.parse(registeredAt),
      qrCode: qrCode,
      isConfirmed: isConfirmed,
    );
  }
}

@JsonSerializable()
class ArticleInfo {
  final int id;
  final String title;
  final String? description;
  final CategoryInfo? category;

  ArticleInfo({
    required this.id,
    required this.title,
    this.description,
    this.category,
  });

  factory ArticleInfo.fromJson(Map<String, dynamic> json) =>
      _$ArticleInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleInfoToJson(this);
}

@JsonSerializable()
class CategoryInfo {
  final int id;
  final String name;

  CategoryInfo({
    required this.id,
    required this.name,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) =>
      _$CategoryInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryInfoToJson(this);
}

@JsonSerializable()
class QRDataModel {
  @JsonKey(name: 'qr_code')
  final String qrCode;
  @JsonKey(name: 'article_id')
  final int articleId;
  @JsonKey(name: 'article_title')
  final String articleTitle;
  @JsonKey(name: 'generated_at')
  final String generatedAt;
  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  QRDataModel({
    required this.qrCode,
    required this.articleId,
    required this.articleTitle,
    required this.generatedAt,
    this.expiresAt,
  });

  factory QRDataModel.fromJson(Map<String, dynamic> json) =>
      _$QRDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$QRDataModelToJson(this);

  QRData toEntity() {
    return QRData(
      qrCode: qrCode,
      articleId: articleId,
      articleTitle: articleTitle,
      generatedAt: DateTime.parse(generatedAt),
      expiresAt: expiresAt != null ? DateTime.parse(expiresAt!) : null,
    );
  }
}

@JsonSerializable()
class StudentStatsModel {
  @JsonKey(name: 'total_attendances')
  final int totalAttendances;
  @JsonKey(name: 'ponente_count')
  final int ponenteCount;
  @JsonKey(name: 'oyente_count')
  final int oyenteCount;
  @JsonKey(name: 'categories_attended')
  final List<String> categoriesAttended;
  @JsonKey(name: 'last_attendance')
  final String? lastAttendance;
  @JsonKey(name: 'articles_presented')
  final int articlesPresented;

  StudentStatsModel({
    required this.totalAttendances,
    required this.ponenteCount,
    required this.oyenteCount,
    required this.categoriesAttended,
    this.lastAttendance,
    required this.articlesPresented,
  });

  factory StudentStatsModel.fromJson(Map<String, dynamic> json) =>
      _$StudentStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentStatsModelToJson(this);

  StudentStats toEntity() {
    return StudentStats(
      totalAttendances: totalAttendances,
      ponenteCount: ponenteCount,
      oyenteCount: oyenteCount,
      categoriesAttended: categoriesAttended,
      lastAttendance:
          lastAttendance != null ? DateTime.parse(lastAttendance!) : null,
      articlesPresented: articlesPresented,
    );
  }
}

@JsonSerializable()
class AttendanceConfirmationModel {
  final bool success;
  final String message;
  final StudentAttendanceModel? attendance;

  AttendanceConfirmationModel({
    required this.success,
    required this.message,
    this.attendance,
  });

  factory AttendanceConfirmationModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceConfirmationModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceConfirmationModelToJson(this);

  AttendanceConfirmation toEntity() {
    return AttendanceConfirmation(
      success: success,
      message: message,
      attendance: attendance?.toEntity(),
    );
  }
}
