import 'package:injectable/injectable.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_admin.dart';
import '../../domain/usecases/login_judge.dart';
import '../../domain/usecases/login_student.dart';
import 'auth_bloc.dart';

@module
abstract class AuthBlocModule {
  @injectable
  AuthBloc authBloc(
    LoginAdmin loginAdmin,
    LoginStudent loginStudent,
    LoginJudge loginJudge,
    AuthRepository authRepository,
  ) =>
      AuthBloc(
        loginAdmin: loginAdmin,
        loginStudent: loginStudent,
        loginJudge: loginJudge,
        authRepository: authRepository,
      );
}
