class RegisterUserRequest {
  RegisterUserRequest({
    required this.email,
    required this.name,
    required this.password,
    required this.confirmPassword,
    required this.phone,
  });

  final String confirmPassword;
  final String email;
  final String name;
  final String password;
  final String phone;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'password_confirmation': confirmPassword,
      'phone': phone,
    };
  }
}
