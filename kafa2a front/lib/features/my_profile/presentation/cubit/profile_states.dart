import 'package:kafa2a/features/my_profile/data/models/language.dart';

class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class ChangeLanguageLoadingState extends ProfileStates {}

class ChangeLanguageSuccessState extends ProfileStates {
  final Language language;

  ChangeLanguageSuccessState(this.language);
}
