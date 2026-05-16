import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/core/di/service_locator.dart';
import 'package:kafa2a/core/widgets/loading_indicator.dart';
import 'package:kafa2a/core/widgets/ui_utils.dart';
import 'package:kafa2a/features/offers/user/presentation/cubit/offers_cubit.dart';
import 'package:kafa2a/features/offers/user/presentation/cubit/offers_states.dart';
import 'package:kafa2a/features/offers/user/presentation/screens/widgets/offer_item_widget.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class UserOffersScreen extends StatelessWidget {
  const UserOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int serviceId = ModalRoute.of(context)!.settings.arguments as int;
    return BlocProvider(
      create: (context) => getIt.get<OffersCubit>()..getOffers(serviceId),
      child: BlocListener<OffersCubit, OffersStates>(
        listener: (context, state) {
          if (state is ManageOfferLoadingState) {
            UIUtils.showLoading(context);
          } else if (state is ManageOfferErrorState) {
            UIUtils.hideLoading(context);
            UIUtils.showMessage(state.error);
          } else if (state is AcceptOfferSuccessState) {
            UIUtils.hideLoading(context);
            UIUtils.showMessage(state.acceptOfferResponse.message!);
            Navigator.pop(context, true);
          } else if (state is RejectOfferSuccessState) {
            UIUtils.hideLoading(context);
            UIUtils.showMessage(AppLocalizations.of(context).rejected);
            context.read<OffersCubit>().getOffers(serviceId);
          } else if (state is CancelRequestSuccessState) {
            UIUtils.hideLoading(context);
            UIUtils.showMessage(AppLocalizations.of(context).requestCancelled);
            Navigator.pop(context, true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).offers),
          ),
          bottomNavigationBar: BlocBuilder<OffersCubit, OffersStates>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {
                      context.read<OffersCubit>().cancelRequest(serviceId);
                    },
                    child: Text(
                      AppLocalizations.of(context).cancelRequest,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
          body: BlocBuilder<OffersCubit, OffersStates>(
            builder: (context, state) {
              final cubit = context.read<OffersCubit>();
              final offers = cubit.offers;
              if (state is OffersLoadingState) {
                return LoadingIndicator();
              } else if (state is OffersErrorState) {
                return Center(child: Text(state.error));
              } else if (offers.isNotEmpty) {
                return ListView.builder(
                  itemCount: offers.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OfferItemWidget(offer: offers[index]),
                  ),
                );
              } else {
                return Center(
                    child: Text(AppLocalizations.of(context).noOffers));
              }
            },
          ),
        ),
        //   child: BlocBuilder<OffersCubit, OffersStates>(
        //     builder: (context, state) {
        //       final cubit = context.read<OffersCubit>();
        //       final offers = cubit.offers;
        //       if (state is OffersLoadingState) {
        //         return LoadingIndicator();
        //       } else if (state is OffersErrorState) {
        //         return Center(child: Text(state.error));
        //       } else if (offers.isNotEmpty) {
        //         return ListView.builder(
        //           itemCount: offers.length,
        //           itemBuilder: (context, index) => Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: OfferItemWidget(offer: offers[index]),
        //           ),
        //         );
        //       } else {
        //         return Center(
        //             child: Text(AppLocalizations.of(context).noOffers));
        //       }
        //     },
        //   ),
        // ),
      ),
    );
  }
}
