import 'package:kafa2a/features/auth/data/models/log_out_response.dart';
import 'package:kafa2a/features/auth/data/models/login_request.dart';
import 'package:kafa2a/features/auth/data/models/register_provider_request.dart';
import 'package:kafa2a/features/auth/data/models/auth_response.dart';
import 'package:kafa2a/features/auth/data/models/register_user_request.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> registerUser(RegisterUserRequest registerUserRequest);

  Future<AuthResponse> registerProvider(
      RegisterProviderRequest registerProviderRequest);

  Future<AuthResponse> loginUser(LoginRequest loginRequest);

  Future<AuthResponse> loginProvider(LoginRequest loginRequest);

  Future<LogOutResponse> logOut(String token);
}
