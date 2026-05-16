import 'package:kafa2a/core/models/user_model.dart';
import 'package:kafa2a/features/auth/domain/entities/user.dart';

extension UserMapper on UserModel {
  User get toUserEntity => User(
        id: id,
        name: name,
        email: email,
        type: type,
        phone: phone,
      );
}
