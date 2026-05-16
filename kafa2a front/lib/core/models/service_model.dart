class ServiceModel {
  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as dynamic,
        categoryId: json['category_id'] as int,
      );

  int categoryId;
  dynamic description;
  int id;
  String name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category_id': categoryId,
      };
}
