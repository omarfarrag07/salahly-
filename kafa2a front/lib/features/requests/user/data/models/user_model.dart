class UserModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String type;
  final String phone;
  final String? policeCertificatePath;
  final String? selfiePath;
  final String? nationalId;
  final String? gender;
  final double? lat;
  final double? lng;
  final String? address;
  final int? serviceId;
  final String status;
  final String? suspendReason;
  final int rating;
  final String? review;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.type,
    required this.phone,
    this.policeCertificatePath,
    this.selfiePath,
    this.nationalId,
    this.gender,
    this.lat,
    this.lng,
    this.address,
    this.serviceId,
    required this.status,
    this.suspendReason,
    required this.rating,
    this.review,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      type: json['type'],
      phone: json['phone'],
      policeCertificatePath: json['police_certificate_path'],
      selfiePath: json['selfie_path'],
      nationalId: json['national_id'],
      gender: json['gender'],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      address: json['address'],
      serviceId: json['service_id'],
      status: json['status'],
      suspendReason: json['suspend_reason'],
      rating: json['rating'],
      review: json['review'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'type': type,
      'phone': phone,
      'police_certificate_path': policeCertificatePath,
      'selfie_path': selfiePath,
      'national_id': nationalId,
      'gender': gender,
      'lat': lat,
      'lng': lng,
      'address': address,
      'service_id': serviceId,
      'status': status,
      'suspend_reason': suspendReason,
      'rating': rating,
      'review': review,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
