import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/di/service_locator.dart';
import 'package:kafa2a/core/widgets/loading_indicator.dart';
import 'package:kafa2a/features/requests/user/presentation/cubit/user_requests_cubit.dart';
import 'package:kafa2a/features/requests/user/presentation/cubit/user_requests_states.dart';
import 'package:kafa2a/features/requests/user/presentation/screens/widgets/request_item_widget.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class UserRequestsScreen extends StatelessWidget {
  const UserRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<UserRequestsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).myRequests),
          actionsPadding: EdgeInsets.only(right: 20.w),
          actions: [
            PopupMenuButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: ColorsManager.blue)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [Text(AppLocalizations.of(context).allRequests)],
                  ),
                  onTap: () =>
                      context.read<UserRequestsCubit>().getAllRequests(),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [Text(AppLocalizations.of(context).pending)],
                  ),
                  onTap: () => context
                      .read<UserRequestsCubit>()
                      .getAllRequests(status: FilterRequestsStatus.pending),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [Text(AppLocalizations.of(context).accepted)],
                  ),
                  onTap: () => context
                      .read<UserRequestsCubit>()
                      .getAllRequests(status: FilterRequestsStatus.accepted),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [Text(AppLocalizations.of(context).completed)],
                  ),
                  onTap: () => context
                      .read<UserRequestsCubit>()
                      .getAllRequests(status: FilterRequestsStatus.paid),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [Text(AppLocalizations.of(context).cancelled)],
                  ),
                  onTap: () => context
                      .read<UserRequestsCubit>()
                      .getAllRequests(status: FilterRequestsStatus.cancelled),
                )
              ],
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt_rounded,
                    color: Colors.black,
                  ),
                  Text(AppLocalizations.of(context).filter)
                ],
              ),
            )
          ],
        ),
        body: BlocBuilder<UserRequestsCubit, UserRequestsStates>(
          builder: (context, state) {
            if (state is UserPendingRequestsLoading) {
              return LoadingIndicator();
            } else if (state is UserPendingRequestsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64.sp,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.error,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (state is UserPendingRequestsSuccess) {
              var requests = state.pendingRequests;
              if (requests.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_rounded,
                        size: 64.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        AppLocalizations.of(context).noRequestsAtTheMoment,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return AnimationLimiter(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 100.h, top: 12.h),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 40.0,
                        child: FadeInAnimation(
                          child: RequestItemWidget(
                            pendingRequests: request,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
