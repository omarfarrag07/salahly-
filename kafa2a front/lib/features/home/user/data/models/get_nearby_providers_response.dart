class GetNearbyProvidersResponse {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? type;
  String? phone;
  String? policeCertificatePath;
  String? selfiePath;
  String? nationalId;
  dynamic gender;
  double? lat;
  double? lng;
  String? address;
  String? serviceId;
  String? status;
  dynamic suspendReason;
  int? rating;
  dynamic review;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? distance;

  GetNearbyProvidersResponse({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.type,
    this.phone,
    this.policeCertificatePath,
    this.selfiePath,
    this.nationalId,
    this.gender,
    this.lat,
    this.lng,
    this.address,
    this.serviceId,
    this.status,
    this.suspendReason,
    this.rating,
    this.review,
    this.createdAt,
    this.updatedAt,
    this.distance,
  });

  factory GetNearbyProvidersResponse.fromJson(Map<String, dynamic> json) {
    return GetNearbyProvidersResponse(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      emailVerifiedAt: json['email_verified_at'] as dynamic,
      type: json['type'] as String?,
      phone: json['phone'] as String?,
      policeCertificatePath: json['police_certificate_path'] as String?,
      selfiePath: json['selfie_path'] as String?,
      nationalId: json['national_id'] as String?,
      gender: json['gender'] as dynamic,
      lat: _parseDouble(json['lat']),
      lng: _parseDouble(json['lng']),
      address: json['address'] as String?,
      serviceId: json['service_id'] as String?,
      status: json['status'] as String?,
      suspendReason: json['suspend_reason'] as dynamic,
      rating: json['rating'] as int?,
      review: json['review'] as dynamic,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      distance: _parseDouble(json['distance']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
