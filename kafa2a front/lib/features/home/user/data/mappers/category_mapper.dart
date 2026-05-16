import 'package:kafa2a/features/home/user/data/mappers/service_mapper.dart';
import 'package:kafa2a/features/home/user/data/models/get_categories_response.dart';
import 'package:kafa2a/features/home/user/domain/entities/category.dart';

extension CategoryMapper on GetCategoriesResponse {
  Category get toCategoryEntity => Category(
        id: id,
        name: name,
        services: services.map((service) => service.toServiceEntity).toList(),
      );
}
