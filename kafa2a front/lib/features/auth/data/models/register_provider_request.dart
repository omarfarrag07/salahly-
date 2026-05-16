import 'dart:io';
import 'package:dio/dio.dart';

class RegisterProviderRequest {
  RegisterProviderRequest(
      {required this.email,
      required this.name,
      required this.password,
      required this.confirmPassword,
      required this.phone,
      required this.nationalId,
      required this.address,
      required this.serviceId,
      required this.policeCertificate,
      required this.selfie,
      required this.lat,
      required this.lng});

  final String address;
  final String confirmPassword;
  final String email;
  final String name;
  final String nationalId;
  final String password;
  final String phone;
  final File policeCertificate;
  final File selfie;
  final int serviceId;
  final double lat;
  final double lng;

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'service_id': serviceId,
      'national_id': nationalId,
      'address': address,
      'phone': phone,
      'police_certificate': await MultipartFile.fromFile(
        policeCertificate.path,
      ),
      'selfie': await MultipartFile.fromFile(
        selfie.path,
      ),
      'lat': lat,
      'lng': lng
    });
  }
}
