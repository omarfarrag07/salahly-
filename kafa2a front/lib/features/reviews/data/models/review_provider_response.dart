class ReviewProviderResponse {
  int? userId;
  int? providerId;
  String? serviceRequestId;
  String? rating;
  String? review;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  ReviewProviderResponse({
    this.userId,
    this.providerId,
    this.serviceRequestId,
    this.rating,
    this.review,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory ReviewProviderResponse.fromJson(Map<String, dynamic> json) {
    return ReviewProviderResponse(
      userId: json['user_id'] as int?,
      providerId: json['provider_id'] as int?,
      serviceRequestId: json['service_request_id'] as String?,
      rating: json['rating'] as String?,
      review: json['review'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      id: json['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'provider_id': providerId,
        'service_request_id': serviceRequestId,
        'rating': rating,
        'review': review,
        'updated_at': updatedAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'id': id,
      };
}
