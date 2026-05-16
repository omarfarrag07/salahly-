import 'package:kafa2a/core/models/user_model.dart';

class Request {
  int? id;
  int? userId;
  int? serviceId;
  String? title;
  String? description;
  String? location;
  String? price;
  String? scheduledAt;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? user;

  Request({
    this.id,
    this.userId,
    this.serviceId,
    this.title,
    this.description,
    this.location,
    this.price,
    this.scheduledAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        serviceId: json['service_id'] as int?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        location: json['location'] as String?,
        price: json['price'] as String?,
        scheduledAt: json['scheduled_at'] as String?,
        status: json['status'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        user: json['user'] == null
            ? null
            : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      );
}
