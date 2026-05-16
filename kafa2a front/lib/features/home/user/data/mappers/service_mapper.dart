import 'package:kafa2a/core/models/service_model.dart';
import 'package:kafa2a/features/home/user/domain/entities/services.dart';

extension ServiceMapper on ServiceModel {
  Services get toServiceEntity => Services(
        id: id,
        name: name,
        description: description,
        categoryId: categoryId,
      );
}
