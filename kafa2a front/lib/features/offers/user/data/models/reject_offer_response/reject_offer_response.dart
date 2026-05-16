class RejectOfferResponse {
  String? message;
  RejectOfferResponse({
    this.message,
  });
  factory RejectOfferResponse.fromJson(Map<String, dynamic> json) {
    return RejectOfferResponse(
      message: json['message'] as String?,
    );
  }
}
