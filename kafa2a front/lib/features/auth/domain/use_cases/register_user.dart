import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/auth/data/models/register_user_request.dart';
import 'package:kafa2a/features/auth/domain/entities/user.dart';
import 'package:kafa2a/features/auth/domain/repository/auth_repository.dart';

@singleton
class RegisterUser {
  RegisterUser(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<User, Failure>> call(RegisterUserRequest registerUserRequest) =>
      _authRepository.registerUser(registerUserRequest);
}
