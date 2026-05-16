import 'package:kafa2a/features/my_profile/data/models/language.dart';

abstract class ProfileLocalDataSource {
  Future<void> changeLanguage(Language language);
  String getLanguage();
}
