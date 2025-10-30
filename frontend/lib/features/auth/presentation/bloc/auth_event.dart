import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginAdminEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginAdminEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class LoginStudentEvent extends AuthEvent {
  final String dni;
  final String studentCode;

  const LoginStudentEvent({
    required this.dni,
    required this.studentCode,
  });

  @override
  List<Object> get props => [dni, studentCode];
}

class LoginJudgeEvent extends AuthEvent {
  final String username;
  final String dni;

  const LoginJudgeEvent({
    required this.username,
    required this.dni,
  });

  @override
  List<Object> get props => [username, dni];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}
