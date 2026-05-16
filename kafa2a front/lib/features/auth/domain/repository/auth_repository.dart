import 'package:dartz/dartz.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/auth/data/models/log_out_response.dart';
import 'package:kafa2a/features/auth/data/models/login_request.dart';
import 'package:kafa2a/features/auth/data/models/register_provider_request.dart';
import 'package:kafa2a/features/auth/data/models/register_user_request.dart';
import 'package:kafa2a/features/auth/domain/entities/provider.dart';
import 'package:kafa2a/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<User, Failure>> registerUser(
      RegisterUserRequest registerUserRequest);

  Future<Either<Provider, Failure>> registerProvider(
      RegisterProviderRequest registerProviderRequest);

  Future<Either<User, Failure>> loginUser(LoginRequest loginRequest);

  Future<Either<Provider, Failure>> loginProvider(LoginRequest loginRequest);

  Future<Either<LogOutResponse, Failure>> logOut();
}
