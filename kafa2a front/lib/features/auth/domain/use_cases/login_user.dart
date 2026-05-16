import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/auth/data/models/login_request.dart';
import 'package:kafa2a/features/auth/domain/entities/user.dart';
import 'package:kafa2a/features/auth/domain/repository/auth_repository.dart';

@singleton
class LoginUser {
  final AuthRepository _authRepository;

  LoginUser(this._authRepository);

  Future<Either<User, Failure>> call(LoginRequest loginRequest) =>
      _authRepository.loginUser(loginRequest);
}
