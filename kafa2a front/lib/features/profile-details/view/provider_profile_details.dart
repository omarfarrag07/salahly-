import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/widgets/ui_utils.dart';
import 'package:kafa2a/features/home/user/presentation/screens/user_main_screen.dart';
import 'package:kafa2a/features/offers/user/data/models/user_offers_response/offers.dart';
import 'package:kafa2a/features/offers/user/presentation/cubit/offers_cubit.dart';
import 'package:kafa2a/features/offers/user/presentation/cubit/offers_states.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class ProviderProfileDetails extends StatelessWidget {
  const ProviderProfileDetails({super.key, required this.offer});
  final Offers offer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).providerProfile),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ColorsManager.blue,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(70.r),
                        child: Image.network(
                          '${ApiConstants.baseImageUrl}${offer.provider.selfiePath}',
                          width: 150.w,
                          height: 150.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person,
                                size: 100.w, color: Colors.grey);
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return SizedBox(
                              width: 100.w,
                              height: 100.w,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "${AppLocalizations.of(context).name}: ${offer.provider.name}",
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${AppLocalizations.of(context).address}: ${offer.provider.address}",
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${AppLocalizations.of(context).offer}: ${offer.price}",
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          "${AppLocalizations.of(context).rating}: ",
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < offer.provider.rating!
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          BlocListener<OffersCubit, OffersStates>(
            listener: (context, state) {
              if (state is ManageOfferLoadingState) {
                UIUtils.showLoading(context);
              } else if (state is ManageOfferErrorState) {
                UIUtils.hideLoading(context);
                UIUtils.showMessage(state.error);
              } else if (state is AcceptOfferSuccessState) {
                UIUtils.hideLoading(context);
                UIUtils.showMessage(state.acceptOfferResponse.message!);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserMainScreen(),
                  ),
                  (route) => true,
                );
              }
            },
            child: ElevatedButton(
              onPressed: () =>
                  context.read<OffersCubit>().acceptOffer(offer.id),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(color: Colors.green, width: 1.2.w))),
              child: Text(
                AppLocalizations.of(context).acceptOffer,
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
