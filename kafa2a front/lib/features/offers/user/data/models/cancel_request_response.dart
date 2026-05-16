class CancelRequestResponse {
  String? message;

  CancelRequestResponse({this.message});

  factory CancelRequestResponse.fromJson(Map<String, dynamic> json) {
    return CancelRequestResponse(
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
