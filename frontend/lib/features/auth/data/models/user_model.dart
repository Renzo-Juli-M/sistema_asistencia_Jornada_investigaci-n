import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int id;
  final String name;
  final String email;
  final String? dni;
  final String? username;
  @JsonKey(name: 'student_code')
  final String? studentCode;
  @JsonKey(name: 'student_type')
  final String? studentType;
  final RoleModel role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.dni,
    this.username,
    this.studentCode,
    this.studentType,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      dni: dni,
      username: username,
      studentCode: studentCode,
      studentType: studentType,
      role: role.toEntity(),
    );
  }
}

@JsonSerializable()
class RoleModel {
  final int id;
  final String name;
  final String? description;

  RoleModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleModelToJson(this);

  RoleEntity toEntity() {
    return RoleEntity(
      id: id,
      name: name,
      description: description,
    );
  }
}
