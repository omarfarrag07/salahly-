import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/core/di/service_locator.dart';
import 'package:kafa2a/core/widgets/loading_indicator.dart';
import 'package:kafa2a/features/home/provider/presentation/cubit/provider_offers_cubit.dart';
import 'package:kafa2a/features/home/provider/presentation/cubit/provider_offers_states.dart';
import 'package:kafa2a/features/home/provider/presentation/screens/widgets/provider_offer_item_widget.dart';

class ProviderHomeTab extends StatelessWidget {
  const ProviderHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<ProviderOffersCubit>(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.h),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 700),
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 30),
                      child: child,
                    ),
                  ),
                  child: Container(
                    color: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 80.h,
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Text(
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? 'مرحباً أستا 😃'
                                : 'Welcome Ostaa 😃',
                            style: TextStyle(
                              color: Color.fromARGB(255, 3, 23, 50),
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.shade200,
                ),
              ],
            ),
          ),
        ),
        body: BlocBuilder<ProviderOffersCubit, ProviderOffersStates>(
          builder: (context, state) {
            if (state is GetAllRequestsLoadingState) {
              return LoadingIndicator();
            } else if (state is GetAllRequestsErrorState) {
              return Center(
                child: Text(state.error),
              );
            } else if (state is GetAllRequestsSuccessState) {
              final pendingRequests = state.requests
                  .where((r) => r.status.toLowerCase() == 'pending')
                  .toList();
              return Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  width: 0.97.sw,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.18),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 20.h),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) =>
                          TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 400 + index * 100),
                        builder: (context, value, child) => Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - value) * 30),
                            child: child,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: ProviderOfferItemWidget(
                            request: pendingRequests[index],
                          ),
                        ),
                      ),
                      itemCount: pendingRequests.length,
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
