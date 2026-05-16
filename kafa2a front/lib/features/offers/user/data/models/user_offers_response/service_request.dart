class ServiceRequest {
  int? id;
  int? userId;
  int? serviceId;
  String? title;
  String? description;
  String? lat;
  String? lng;
  dynamic address;
  String? price;
  String? scheduledAt;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  ServiceRequest({
    this.id,
    this.userId,
    this.serviceId,
    this.title,
    this.description,
    this.lat,
    this.lng,
    this.address,
    this.price,
    this.scheduledAt,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      serviceId: json['service_id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      lat: json['lat'] as String?,
      lng: json['lng'] as String?,
      address: json['address'] as dynamic,
      price: json['price'] as String?,
      scheduledAt: json['scheduled_at'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'service_id': serviceId,
        'title': title,
        'description': description,
        'lat': lat,
        'lng': lng,
        'address': address,
        'price': price,
        'scheduled_at': scheduledAt,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
