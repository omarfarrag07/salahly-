import '../../../../../core/models/service_model.dart';

class GetCategoriesResponse {
  int id;
  String name;
  List<ServiceModel> services;

  GetCategoriesResponse({
    required this.id,
    required this.name,
    required this.services,
  });

  factory GetCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return GetCategoriesResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      services: (json['services'] as List<dynamic>)
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
