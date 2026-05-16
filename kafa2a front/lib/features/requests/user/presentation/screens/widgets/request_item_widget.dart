import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/config/routes_manager.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/features/profile-details/view/provider_profile_not_accepted_details.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_requests/all_requests.dart';
import 'package:kafa2a/features/requests/user/presentation/cubit/user_requests_cubit.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class RequestItemWidget extends StatelessWidget {
  const RequestItemWidget({super.key, required this.pendingRequests});
  final AllRequests pendingRequests;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (pendingRequests.status == FilterRequestsStatus.completed) {
          Navigator.pushNamed(context, RoutesManager.payment,
              arguments: pendingRequests);
        } else if (pendingRequests.status == FilterRequestsStatus.accepted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProviderProfileViewScreen(offer: pendingRequests),
              ));
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pendingRequests.title,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorsManager.blue,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              pendingRequests.description,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded,
                                    size: 18.sp, color: Colors.grey[600]),
                                SizedBox(width: 6.w),
                                Text(
                                  _formatDateTime(
                                      context, pendingRequests.scheduledAt),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _buildStatusBox(context, pendingRequests.status),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                        pendingRequests.status == FilterRequestsStatus.pending
                            ? OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 6.h),
                                  side: BorderSide(
                                      color: ColorsManager.blue, width: 1.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RoutesManager.offerUser,
                                    arguments: pendingRequests.id,
                                  ).then((value) {
                                    if (value == true) {
                                      if (context.mounted) {
                                        context
                                            .read<UserRequestsCubit>()
                                            .getAllRequests();
                                      }
                                    }
                                  });
                                },
                                icon: Icon(Icons.check_circle_rounded,
                                    color: ColorsManager.blue, size: 18.sp),
                                label: Text(
                                  AppLocalizations.of(context).viewAllOffers,
                                  style: TextStyle(
                                    color: ColorsManager.blue,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : SizedBox(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(BuildContext context, String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final locale = Localizations.localeOf(context);
      final dateFormat = DateFormat('dd/MM/yyyy HH:mm', locale.languageCode);
      return dateFormat.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  Widget _buildStatusBox(BuildContext context, String status) {
    Color color;
    IconData icon;
    String label;
    switch (status) {
      case 'pending':
        color = Colors.amber;
        icon = Icons.hourglass_top_rounded;
        label = AppLocalizations.of(context).pending;
        break;
      case 'accepted':
        color = Colors.orange;
        icon = Icons.check_rounded;
        label = AppLocalizations.of(context).accepted;
        break;
      case 'completed':
        color = Colors.green;
        icon = Icons.check_circle_rounded;
        label = AppLocalizations.of(context).completed;
        break;
      case 'paid':
        color = Colors.blue;
        icon = Icons.attach_money_rounded;
        label = AppLocalizations.of(context).paid;
        break;
      default:
        color = Colors.grey;
        icon = Icons.info_outline_rounded;
        label = status;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
