import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/features/my_profile/data/data_sources/local/profile_local_data_source.dart';
import 'package:kafa2a/features/my_profile/data/models/language.dart';
import 'package:kafa2a/features/my_profile/presentation/cubit/profile_states.dart';

@singleton
class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit(this._profileLocalDataSource) : super(ProfileInitialState());
  final ProfileLocalDataSource _profileLocalDataSource;

  void changeLanguage(Language language) {
    _profileLocalDataSource.changeLanguage(language);
    emit(ChangeLanguageSuccessState(language));
  }

  String getLanguage() {
    return _profileLocalDataSource.getLanguage();
  }

  String get selectedLanguageCode => getLanguage();
}
