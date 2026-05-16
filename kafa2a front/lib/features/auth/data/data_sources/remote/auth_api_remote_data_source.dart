import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/messages.dart';
import 'package:kafa2a/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:kafa2a/features/auth/data/models/log_out_response.dart';
import 'package:kafa2a/features/auth/data/models/login_request.dart';
import 'package:kafa2a/features/auth/data/models/register_provider_request.dart';
import 'package:kafa2a/features/auth/data/models/auth_response.dart';
import 'package:kafa2a/features/auth/data/models/register_user_request.dart';

@Singleton(as: AuthRemoteDataSource)
class AuthApiRemoteDataSource extends AuthRemoteDataSource {
  AuthApiRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<LogOutResponse> logOut(String token) async {
    try {
      final Response response = await _dio.post(
        ApiConstants.logOutEndPoint,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return LogOutResponse.fromJson(response.data);
    } catch (exception) {
      String errorMessage = Messages.failedToLogOut;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw RemoteException(errorMessage);
    }
  }

  @override
  Future<AuthResponse> loginProvider(LoginRequest loginRequest) async {
    try {
      final Response response = await _dio.post(
        ApiConstants.loginProviderEndPoint,
        data: loginRequest.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } catch (exception) {
      String errorMessage = Messages.failedToLogin;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw (RemoteException(errorMessage));
    }
  }

  @override
  Future<AuthResponse> loginUser(LoginRequest loginRequest) async {
    try {
      final Response response = await _dio.post(
        ApiConstants.loginUserEndPoint,
        data: loginRequest.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } catch (exception) {
      String errorMessage = Messages.failedToLogin;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw (RemoteException(errorMessage));
    }
  }

  @override
  Future<AuthResponse> registerProvider(
      RegisterProviderRequest registerProviderRequest) async {
    try {
      final Response response = await _dio.post(
        ApiConstants.registerProviderEndPoint,
        data: await registerProviderRequest.toFormData(),
      );
      return AuthResponse.fromJson(response.data);
    } catch (exception) {
      String errorMessage = Messages.failedToRegister;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw (RemoteException(errorMessage));
    }
  }

  @override
  Future<AuthResponse> registerUser(
      RegisterUserRequest registerUserRequest) async {
    try {
      final Response response = await _dio.post(
        ApiConstants.registerUserEndPoint,
        data: registerUserRequest.toJson(),
      );
      return AuthResponse.fromJson(response.data);
    } catch (exception) {
      String errorMessage = Messages.failedToRegister;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw (RemoteException(errorMessage));
    }
  }
}
