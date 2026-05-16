class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.type,
    required this.phone,
    this.address,
    this.policeCertificatePath,
    this.selfiePath,
    this.nationalId,
    this.gender,
    this.serviceId,
    this.lat,
    this.lng,
    this.status,
    this.suspendReason,
    this.rating,
    this.review,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        emailVerifiedAt: json['email_verified_at'] as dynamic,
        type: json['type'] as String,
        phone: json['phone'] as String,
        address: json['address'] as String?,
        policeCertificatePath: json['police_certificate_path'] as String?,
        selfiePath: json['selfie_path'] as String?,
        nationalId: json['national_id'] as String?,
        gender: json['gender'] as String?,
        serviceId: json['service_id'] as String?,
        lat: _parseDouble(json['lat']),
        lng: _parseDouble(json['lng']),
        status: json['status'] as String?,
        suspendReason: json['suspend_reason'] as String?,
        rating: json['rating'] as int?,
        review: json['review'] as dynamic,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  String? address;
  DateTime createdAt;
  String email;
  dynamic emailVerifiedAt;
  String? gender;
  int id;
  String name;
  String? nationalId;
  String phone;
  String? policeCertificatePath;
  String? selfiePath;
  String? serviceId;
  String type;
  DateTime updatedAt;
  double? lat;
  double? lng;
  String? status;
  String? suspendReason;
  int? rating;
  dynamic review;

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
