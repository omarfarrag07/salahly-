class ReviewProviderRequest {
  ReviewProviderRequest({
    required this.rating,
    required this.review,
    required this.serviceRequestId,
  });

  final int rating;
  final String? review;
  final int serviceRequestId;

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'review': review,
        'service_request_id': serviceRequestId,
      };
}
