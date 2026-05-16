// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:kafa2a/core/di/register_module.dart' as _i213;
import 'package:kafa2a/core/local_data_source/local_data_source.dart' as _i819;
import 'package:kafa2a/core/local_data_source/shared_pref_local_data_source.dart'
    as _i90;
import 'package:kafa2a/core/utils/access_location.dart' as _i766;
import 'package:kafa2a/core/utils/pusher_notification.dart' as _i599;
import 'package:kafa2a/features/auth/data/data_sources/local/auth_local_data_source.dart'
    as _i819;
import 'package:kafa2a/features/auth/data/data_sources/local/auth_shared_pref_local_data_source.dart'
    as _i818;
import 'package:kafa2a/features/auth/data/data_sources/remote/auth_api_remote_data_source.dart'
    as _i386;
import 'package:kafa2a/features/auth/data/data_sources/remote/auth_remote_data_source.dart'
    as _i755;
import 'package:kafa2a/features/auth/data/repository/auth_repository_impl.dart'
    as _i887;
import 'package:kafa2a/features/auth/domain/repository/auth_repository.dart'
    as _i998;
import 'package:kafa2a/features/auth/domain/use_cases/log_out.dart' as _i23;
import 'package:kafa2a/features/auth/domain/use_cases/login_provider.dart'
    as _i160;
import 'package:kafa2a/features/auth/domain/use_cases/login_user.dart' as _i684;
import 'package:kafa2a/features/auth/domain/use_cases/register_provider.dart'
    as _i619;
import 'package:kafa2a/features/auth/domain/use_cases/register_user.dart'
    as _i0;
import 'package:kafa2a/features/auth/presentation/cubit/auth_cubit.dart'
    as _i290;
import 'package:kafa2a/features/home/provider/data/data_source/provider_offers_api_data_source.dart'
    as _i0;
import 'package:kafa2a/features/home/provider/data/data_source/provider_offers_remote_data_source.dart'
    as _i633;
import 'package:kafa2a/features/home/provider/data/repository/provider_offers_repository.dart'
    as _i723;
import 'package:kafa2a/features/home/provider/domain/repository/provider_offers_repository.dart'
    as _i1052;
import 'package:kafa2a/features/home/provider/domain/use_cases/get_all_requests.dart'
    as _i995;
import 'package:kafa2a/features/home/provider/domain/use_cases/send_offer.dart'
    as _i616;
import 'package:kafa2a/features/home/provider/presentation/cubit/provider_offers_cubit.dart'
    as _i42;
import 'package:kafa2a/features/home/user/data/data_sources/map/map_api_data_source.dart'
    as _i35;
import 'package:kafa2a/features/home/user/data/data_sources/map/map_remote_data_source.dart'
    as _i932;
import 'package:kafa2a/features/home/user/data/data_sources/request_service_api_data_source.dart'
    as _i195;
import 'package:kafa2a/features/home/user/data/data_sources/request_service_remote_data_source.dart'
    as _i519;
import 'package:kafa2a/features/home/user/data/repository/map_repository_impl.dart'
    as _i122;
import 'package:kafa2a/features/home/user/data/repository/request_service_repository_impl.dart'
    as _i142;
import 'package:kafa2a/features/home/user/domain/repository/map_repository.dart'
    as _i608;
import 'package:kafa2a/features/home/user/domain/repository/request_service_repository.dart'
    as _i234;
import 'package:kafa2a/features/home/user/domain/use_cases/get_all_categories.dart'
    as _i86;
import 'package:kafa2a/features/home/user/domain/use_cases/get_nearby_categories.dart'
    as _i197;
import 'package:kafa2a/features/home/user/domain/use_cases/request_service.dart'
    as _i574;
import 'package:kafa2a/features/home/user/presentation/cubit/map/map_cubit.dart'
    as _i918;
import 'package:kafa2a/features/home/user/presentation/cubit/request_service/request_service_cubit.dart'
    as _i420;
import 'package:kafa2a/features/my_profile/data/data_sources/local/profile_local_data_source.dart'
    as _i796;
import 'package:kafa2a/features/my_profile/data/data_sources/local/profile_shared_pref_local_data_source.dart'
    as _i50;
import 'package:kafa2a/features/my_profile/presentation/cubit/profile_cubit.dart'
    as _i944;
import 'package:kafa2a/features/offers/user/data/data_sources/offers_user_api_data_source.dart'
    as _i444;
import 'package:kafa2a/features/offers/user/data/data_sources/offers_user_remote_data_source.dart'
    as _i20;
import 'package:kafa2a/features/offers/user/data/repository/offers_repository_impl.dart'
    as _i958;
import 'package:kafa2a/features/offers/user/domain/repository/offers_repository.dart'
    as _i607;
import 'package:kafa2a/features/offers/user/domain/use_cases/accept_offer.dart'
    as _i95;
import 'package:kafa2a/features/offers/user/domain/use_cases/cancel_request.dart'
    as _i29;
import 'package:kafa2a/features/offers/user/domain/use_cases/get_offers.dart'
    as _i888;
import 'package:kafa2a/features/offers/user/domain/use_cases/reject_offer.dart'
    as _i231;
import 'package:kafa2a/features/offers/user/presentation/cubit/offers_cubit.dart'
    as _i1017;
import 'package:kafa2a/features/payment/data/data_sources/payment_api_data_source.dart'
    as _i644;
import 'package:kafa2a/features/payment/data/data_sources/payment_remote_data_source.dart'
    as _i340;
import 'package:kafa2a/features/payment/data/repository/payment_repository_impl.dart'
    as _i978;
import 'package:kafa2a/features/payment/domain/repository/payment_repository.dart'
    as _i154;
import 'package:kafa2a/features/payment/domain/use_cases/pay_provider.dart'
    as _i583;
import 'package:kafa2a/features/payment/presentation/cubit/payment_cubit.dart'
    as _i505;
import 'package:kafa2a/features/requests/user/data/data_sources/remote/service_requests_remote_data_source.dart'
    as _i277;
import 'package:kafa2a/features/requests/user/data/data_sources/user_requests_api_data_source.dart'
    as _i652;
import 'package:kafa2a/features/requests/user/data/data_sources/user_requests_remote_data_source.dart'
    as _i444;
import 'package:kafa2a/features/requests/user/data/repository/service_requests_repository_impl.dart'
    as _i659;
import 'package:kafa2a/features/requests/user/data/repository/user_requests_repository_impl.dart'
    as _i514;
import 'package:kafa2a/features/requests/user/domain/repository/service_requests_repository.dart'
    as _i974;
import 'package:kafa2a/features/requests/user/domain/repository/user_requests_repository.dart'
    as _i598;
import 'package:kafa2a/features/requests/user/domain/use_cases/get_accepted_requests.dart'
    as _i995;
import 'package:kafa2a/features/requests/user/domain/use_cases/get_all_service_requests.dart'
    as _i960;
import 'package:kafa2a/features/requests/user/domain/use_cases/get_all_user_requests.dart'
    as _i739;
import 'package:kafa2a/features/requests/user/domain/use_cases/get_pending_requests.dart'
    as _i314;
import 'package:kafa2a/features/requests/user/domain/use_cases/get_service_request_by_id.dart'
    as _i157;
import 'package:kafa2a/features/requests/user/presentation/cubit/user_requests_cubit.dart'
    as _i838;
import 'package:kafa2a/features/reviews/data/data_source/review_provider_api_data_source.dart'
    as _i416;
import 'package:kafa2a/features/reviews/data/data_source/review_provider_remote_data_source.dart'
    as _i1072;
import 'package:kafa2a/features/reviews/data/repository/review_provider_repostiory_impl.dart'
    as _i39;
import 'package:kafa2a/features/reviews/domain/repository/review_provider_repository.dart'
    as _i369;
import 'package:kafa2a/features/reviews/domain/use_cases/review_provider.dart'
    as _i1019;
import 'package:kafa2a/features/reviews/presentation/cubit/review_provider_cubit.dart'
    as _i45;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPref,
      preResolve: true,
    );
    gh.singleton<_i361.Dio>(() => registerModule.dio);
    gh.singleton<_i755.AuthRemoteDataSource>(
        () => _i386.AuthApiRemoteDataSource(gh<_i361.Dio>()));
    gh.factory<_i340.PaymentRemoteDataSource>(
        () => _i644.PaymentApiDataSource(gh<_i361.Dio>()));
    gh.factory<_i932.MapRemoteDataSource>(
        () => _i35.MapApiDataSource(gh<_i361.Dio>()));
    gh.factory<_i20.OffersUserRemoteDataSource>(
        () => _i444.OffersUserApiDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i444.UserRequestsRemoteDataSource>(
        () => _i652.UserRequestsApiDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i633.ProviderOffersRemoteDataSource>(
        () => _i0.ProviderOffersApiDataSource(gh<_i361.Dio>()));
    gh.factory<_i1072.ReviewProviderRemoteDataSource>(
        () => _i416.ReviewProviderApiDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i796.ProfileLocalDataSource>(() =>
        _i50.ProfileSharedPrefLocalDataSource(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i819.LocalDataSource>(
        () => _i90.SharedPrefLocalDataSource(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i519.RequestServiceRemoteDataSource>(
        () => _i195.RequestServiceApiDataSource(
              gh<_i361.Dio>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.singleton<_i819.AuthLocalDataSource>(() =>
        _i818.AuthSharedPrefLocalDataSource(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i766.AccessLocation>(
        () => _i766.AccessLocation(gh<_i819.LocalDataSource>()));
    gh.factory<_i599.PusherService>(() => _i599.PusherService(
          gh<_i361.Dio>(),
          gh<_i819.AuthLocalDataSource>(),
        ));
    gh.lazySingleton<_i1052.ProviderOffersRepository>(
        () => _i723.ProviderOffersRepositoryImpl(
              gh<_i633.ProviderOffersRemoteDataSource>(),
              gh<_i819.AuthLocalDataSource>(),
            ));
    gh.factory<_i369.ReviewProviderRepository>(
        () => _i39.ReviewProviderRepostioryImpl(
              gh<_i1072.ReviewProviderRemoteDataSource>(),
              gh<_i819.AuthLocalDataSource>(),
            ));
    gh.factory<_i607.OffersRepository>(() => _i958.OffersRepositoryImpl(
          gh<_i819.AuthLocalDataSource>(),
          gh<_i20.OffersUserRemoteDataSource>(),
        ));
    gh.singleton<_i998.AuthRepository>(() => _i887.AuthRepositoryImpl(
          gh<_i755.AuthRemoteDataSource>(),
          gh<_i819.AuthLocalDataSource>(),
        ));
    gh.singleton<_i995.GetAllRequests>(
        () => _i995.GetAllRequests(gh<_i1052.ProviderOffersRepository>()));
    gh.singleton<_i616.SendOffer>(
        () => _i616.SendOffer(gh<_i1052.ProviderOffersRepository>()));
    gh.factory<_i608.MapRepository>(() => _i122.MapRepositoryImpl(
          gh<_i819.AuthLocalDataSource>(),
          gh<_i932.MapRemoteDataSource>(),
        ));
    gh.factory<_i234.RequestServiceRepository>(
        () => _i142.RequestServiceRepositoryImpl(
              gh<_i519.RequestServiceRemoteDataSource>(),
              gh<_i819.AuthLocalDataSource>(),
            ));
    gh.factory<_i277.ServiceRequestsRemoteDataSource>(
        () => _i277.ServiceRequestsRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i819.LocalDataSource>(),
            ));
    gh.singleton<_i944.ProfileCubit>(
        () => _i944.ProfileCubit(gh<_i796.ProfileLocalDataSource>()));
    gh.factory<_i197.GetNearbyCategories>(
        () => _i197.GetNearbyCategories(gh<_i608.MapRepository>()));
    gh.factory<_i974.ServiceRequestsRepository>(() =>
        _i659.ServiceRequestsRepositoryImpl(
            gh<_i277.ServiceRequestsRemoteDataSource>()));
    gh.factory<_i918.MapCubit>(() => _i918.MapCubit(
          gh<_i766.AccessLocation>(),
          gh<_i197.GetNearbyCategories>(),
        ));
    gh.factory<_i1019.ReviewProvider>(
        () => _i1019.ReviewProvider(gh<_i369.ReviewProviderRepository>()));
    gh.factory<_i45.ReviewProviderCubit>(
        () => _i45.ReviewProviderCubit(gh<_i1019.ReviewProvider>()));
    gh.singleton<_i231.RejectOffer>(
        () => _i231.RejectOffer(gh<_i607.OffersRepository>()));
    gh.lazySingleton<_i95.AcceptOffer>(
        () => _i95.AcceptOffer(gh<_i607.OffersRepository>()));
    gh.lazySingleton<_i29.CancelRequest>(
        () => _i29.CancelRequest(gh<_i607.OffersRepository>()));
    gh.lazySingleton<_i888.GetOffers>(
        () => _i888.GetOffers(gh<_i607.OffersRepository>()));
    gh.factory<_i154.PaymentRepository>(() => _i978.PaymentRepositoryImpl(
          gh<_i340.PaymentRemoteDataSource>(),
          gh<_i819.AuthLocalDataSource>(),
        ));
    gh.factory<_i960.GetAllServiceRequests>(() =>
        _i960.GetAllServiceRequests(gh<_i974.ServiceRequestsRepository>()));
    gh.factory<_i157.GetServiceRequestById>(() =>
        _i157.GetServiceRequestById(gh<_i974.ServiceRequestsRepository>()));
    gh.factory<_i598.UserRequestsRepository>(
        () => _i514.UserRequestsRepositoryImpl(
              gh<_i819.AuthLocalDataSource>(),
              gh<_i444.UserRequestsRemoteDataSource>(),
            ));
    gh.singleton<_i160.LoginProvider>(
        () => _i160.LoginProvider(gh<_i998.AuthRepository>()));
    gh.singleton<_i684.LoginUser>(
        () => _i684.LoginUser(gh<_i998.AuthRepository>()));
    gh.singleton<_i23.LogOut>(() => _i23.LogOut(gh<_i998.AuthRepository>()));
    gh.singleton<_i619.RegisterProvider>(
        () => _i619.RegisterProvider(gh<_i998.AuthRepository>()));
    gh.singleton<_i0.RegisterUser>(
        () => _i0.RegisterUser(gh<_i998.AuthRepository>()));
    gh.factory<_i739.GetAllUserRequests>(
        () => _i739.GetAllUserRequests(gh<_i598.UserRequestsRepository>()));
    gh.lazySingleton<_i995.GetAcceptedRequests>(
        () => _i995.GetAcceptedRequests(gh<_i598.UserRequestsRepository>()));
    gh.lazySingleton<_i314.GetPendingRequests>(
        () => _i314.GetPendingRequests(gh<_i598.UserRequestsRepository>()));
    gh.factory<_i42.ProviderOffersCubit>(() => _i42.ProviderOffersCubit(
          gh<_i995.GetAllRequests>(),
          gh<_i616.SendOffer>(),
          gh<_i1052.ProviderOffersRepository>(),
        ));
    gh.factory<_i1017.OffersCubit>(() => _i1017.OffersCubit(
          gh<_i888.GetOffers>(),
          gh<_i95.AcceptOffer>(),
          gh<_i231.RejectOffer>(),
          gh<_i29.CancelRequest>(),
        ));
    gh.singleton<_i574.RequestService>(
        () => _i574.RequestService(gh<_i234.RequestServiceRepository>()));
    gh.factory<_i86.GetAllCategories>(
        () => _i86.GetAllCategories(gh<_i234.RequestServiceRepository>()));
    gh.factory<_i838.UserRequestsCubit>(() => _i838.UserRequestsCubit(
          gh<_i995.GetAcceptedRequests>(),
          gh<_i739.GetAllUserRequests>(),
        ));
    gh.singleton<_i290.AuthCubit>(() => _i290.AuthCubit(
          gh<_i684.LoginUser>(),
          gh<_i160.LoginProvider>(),
          gh<_i0.RegisterUser>(),
          gh<_i619.RegisterProvider>(),
          gh<_i23.LogOut>(),
          gh<_i766.AccessLocation>(),
        ));
    gh.factory<_i583.PayProvider>(
        () => _i583.PayProvider(gh<_i154.PaymentRepository>()));
    gh.factory<_i505.PaymentCubit>(
        () => _i505.PaymentCubit(gh<_i583.PayProvider>()));
    gh.factory<_i420.RequestServiceCubit>(() => _i420.RequestServiceCubit(
          gh<_i86.GetAllCategories>(),
          gh<_i574.RequestService>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i213.RegisterModule {}
