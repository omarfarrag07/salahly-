import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:kafa2a/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:kafa2a/features/auth/data/mappers/provider_mapper.dart';
import 'package:kafa2a/features/auth/data/mappers/user_mapper.dart';
import 'package:kafa2a/features/auth/data/models/log_out_response.dart';
import 'package:kafa2a/features/auth/data/models/login_request.dart';
import 'package:kafa2a/features/auth/data/models/register_provider_request.dart';
import 'package:kafa2a/features/auth/data/models/auth_response.dart';
import 'package:kafa2a/features/auth/data/models/register_user_request.dart';
import 'package:kafa2a/features/auth/domain/entities/provider.dart';
import 'package:kafa2a/features/auth/domain/entities/user.dart';
import 'package:kafa2a/features/auth/domain/repository/auth_repository.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._authLocalDataSource,
  );

  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteDataSource _authRemoteDataSource;

  @override
  Future<Either<User, Failure>> registerUser(
      RegisterUserRequest registerUserRequest) async {
    try {
      final AuthResponse response =
          await _authRemoteDataSource.registerUser(registerUserRequest);
      _authLocalDataSource.saveToken(response.token!);
      return Left(response.user!.toUserEntity);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }

  @override
  Future<Either<Provider, Failure>> registerProvider(
      RegisterProviderRequest registerProviderRequest) async {
    try {
      final AuthResponse response =
          await _authRemoteDataSource.registerProvider(registerProviderRequest);
      _authLocalDataSource.saveToken(response.token!);
      return Left(response.user!.toProviderEntity);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }

  @override
  Future<Either<User, Failure>> loginUser(LoginRequest loginRequest) async {
    try {
      final response = await _authRemoteDataSource.loginUser(loginRequest);
      _authLocalDataSource.saveToken(response.token!);
      return Left(response.user!.toUserEntity);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }

  @override
  Future<Either<Provider, Failure>> loginProvider(
      LoginRequest loginRequest) async {
    try {
      final response = await _authRemoteDataSource.loginProvider(loginRequest);
      _authLocalDataSource.saveToken(response.token!);
      return Left(response.user!.toProviderEntity);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }

  @override
  Future<Either<LogOutResponse, Failure>> logOut() async {
    try {
      final String token = _authLocalDataSource.getToken();
      final LogOutResponse response = await _authRemoteDataSource.logOut(token);
      _authLocalDataSource.removeToken();
      return Left(response);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }
}
