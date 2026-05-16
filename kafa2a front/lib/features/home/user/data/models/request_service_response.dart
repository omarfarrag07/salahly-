class RequestServiceResponse {
  int? serviceId;
  String? description;
  String? location;
  String? scheduledAt;
  int? price;
  String? status;
  int? userId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  RequestServiceResponse({
    this.serviceId,
    this.description,
    this.location,
    this.scheduledAt,
    this.price,
    this.status,
    this.userId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory RequestServiceResponse.fromJson(Map<String, dynamic> json) {
    return RequestServiceResponse(
      serviceId: json['service_id'] as int?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      scheduledAt: json['scheduled_at'] as String?,
      price: json['price'] as int?,
      status: json['status'] as String?,
      userId: json['user_id'] as int?,
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
        'service_id': serviceId,
        'description': description,
        'location': location,
        'scheduled_at': scheduledAt,
        'price': price,
        'status': status,
        'user_id': userId,
        'updated_at': updatedAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'id': id,
      };
}
