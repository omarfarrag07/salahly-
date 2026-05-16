import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/features/offers/user/data/models/user_offers_response/offers.dart';
import 'package:kafa2a/features/offers/user/presentation/cubit/offers_cubit.dart';
import 'package:kafa2a/features/profile-details/view/provider_profile_details.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class OfferItemWidget extends StatelessWidget {
  const OfferItemWidget({super.key, required this.offer});
  final Offers offer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<OffersCubit>(),
              child: ProviderProfileDetails(
                offer: offer,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: Image.network(
                      '${ApiConstants.baseImageUrl}${offer.provider.selfiePath}',
                      width: 70.w,
                      height: 70.w,
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
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.provider.name,
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
                  )
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    "${AppLocalizations.of(context).price}: ${offer.price}",
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: Colors.green.withOpacity(0.15),
                    child: IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () =>
                          context.read<OffersCubit>().acceptOffer(offer.id),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: Colors.red.withOpacity(0.15),
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () =>
                          context.read<OffersCubit>().rejectOffer(offer.id),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
