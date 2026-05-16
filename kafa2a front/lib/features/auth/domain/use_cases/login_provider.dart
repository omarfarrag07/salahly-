import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/auth/data/models/login_request.dart';
import 'package:kafa2a/features/auth/domain/entities/provider.dart';
import 'package:kafa2a/features/auth/domain/repository/auth_repository.dart';

@singleton
class LoginProvider {
  final AuthRepository _authRepository;

  LoginProvider(this._authRepository);

  Future<Either<Provider, Failure>> call(LoginRequest loginRequest) =>
      _authRepository.loginProvider(loginRequest);
}
