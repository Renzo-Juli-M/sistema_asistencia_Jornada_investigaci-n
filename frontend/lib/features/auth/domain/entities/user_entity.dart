import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? dni;
  final String? username;
  final String? studentCode;
  final String? studentType;
  final RoleEntity role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.dni,
    this.username,
    this.studentCode,
    this.studentType,
    required this.role,
  });

  bool get isAdmin => role.name == 'admin';
  bool get isJudge => role.name == 'jurado';
  bool get isStudent => role.name == 'alumno';
  bool get isPonente => isStudent && studentType == 'ponente';
  bool get isOyente => isStudent && studentType == 'oyente';

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        dni,
        username,
        studentCode,
        studentType,
        role,
      ];
}

class RoleEntity extends Equatable {
  final int id;
  final String name;
  final String? description;

  const RoleEntity({
    required this.id,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}
