import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/core/widgets/loading_indicator.dart';
import 'package:kafa2a/features/home/provider/presentation/cubit/provider_offers_cubit.dart';
import 'package:kafa2a/features/home/provider/presentation/cubit/provider_offers_states.dart';
import 'package:kafa2a/features/home/provider/presentation/screens/widgets/provider_offer_item_widget.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class ScheduledJobsScreen extends StatelessWidget {
  const ScheduledJobsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProviderOffersCubit, ProviderOffersStates>(
      listener: (context, state) {
        if (state is SendOfferLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(child: CircularProgressIndicator()),
          );
        } else if (state is SendOfferSuccessState) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is SendOfferErrorState) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: BlocBuilder<ProviderOffersCubit, ProviderOffersStates>(
        builder: (context, state) {
          if (state is GetAllRequestsLoadingState) {
            return LoadingIndicator();
          } else if (state is GetAllRequestsErrorState) {
            return Center(child: Text(state.error));
          } else if (state is GetAllRequestsSuccessState) {
            final scheduledStatuses = ['accepted', 'completed', 'paid'];
            final scheduledRequests = state.requests
                .where(
                    (r) => scheduledStatuses.contains(r.status.toLowerCase()))
                .toList();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16.h),
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
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 18.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.13),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context).appointments,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              AppLocalizations.of(context).appointmentsSubtitle,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Center(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                        padding: EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 80.h),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: scheduledRequests.length,
                          itemBuilder: (context, index) {
                            final req = scheduledRequests[index];
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration:
                                  Duration(milliseconds: 400 + index * 100),
                              builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - value) * 30),
                                  child: child,
                                ),
                              ),
                              child: Column(
                                children: [
                                  ProviderOfferItemWidget(
                                    request: req,
                                    customFooter:
                                        _buildStatusFooter(context, req),
                                  ),
                                  SizedBox(height: 8.h),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildStatusFooter(BuildContext context, dynamic req) {
    final status = req.status.toLowerCase();
    if (status == 'accepted') {
      return Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[700],
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              textStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
            onPressed: () {
              context.read<ProviderOffersCubit>().completeRequest(req.id);
            },
            icon: Icon(Icons.assignment_turned_in,
                color: Colors.black, size: 22.sp),
            label: Text(AppLocalizations.of(context).done),
          ),
        ),
      );
    } else if (status == 'completed') {
      return Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_bottom,
                color: Colors.orange[800], size: 22.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                AppLocalizations.of(context).waitingToGetPaid,
                style: TextStyle(
                  color: Colors.orange[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    } else if (status == 'paid') {
      return Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green[800], size: 22.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                AppLocalizations.of(context).paidSuccessfully,
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }
}
