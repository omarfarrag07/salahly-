class LogOutResponse {
  LogOutResponse({required this.message});

  factory LogOutResponse.fromJson(Map<String, dynamic> json) {
    return LogOutResponse(
      message: json['message'] as String,
    );
  }

  String message;
}
