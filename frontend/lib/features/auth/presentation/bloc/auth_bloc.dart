import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_admin.dart';
import '../../domain/usecases/login_student.dart';
import '../../domain/usecases/login_judge.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginAdmin loginAdmin;
  final LoginStudent loginStudent;
  final LoginJudge loginJudge;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginAdmin,
    required this.loginStudent,
    required this.loginJudge,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<LoginAdminEvent>(_onLoginAdmin);
    on<LoginStudentEvent>(_onLoginStudent);
    on<LoginJudgeEvent>(_onLoginJudge);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLoginAdmin(
    LoginAdminEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginAdmin(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLoginStudent(
    LoginStudentEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginStudent(
      dni: event.dni,
      studentCode: event.studentCode,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLoginJudge(
    LoginJudgeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginJudge(
      username: event.username,
      dni: event.dni,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await authRepository.getCurrentUser();

    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
