import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/core/di/service_locator.dart';
import 'package:kafa2a/core/widgets/loading_indicator.dart';
import 'package:kafa2a/features/accepted_requests/view/widgets/accepted_request_item_widget.dart';
import 'package:kafa2a/features/requests/user/presentation/cubit/user_requests_cubit.dart';
import 'package:kafa2a/features/requests/user/presentation/cubit/user_requests_states.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class AcceptedRequestsScreen extends StatelessWidget {
  const AcceptedRequestsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<UserRequestsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).acceptedRequests),
          centerTitle: true,
        ),
        body: BlocBuilder<UserRequestsCubit, UserRequestsStates>(
          builder: (context, state) {
            if (state is UserPendingRequestsLoading) {
              return LoadingIndicator();
            } else if (state is UserPendingRequestsError) {
              return Center(child: Text(state.error));
            } else if (state is UserPendingRequestsSuccess) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 10.h),
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: AcceptedRequestItemWidget(
                            acceptedRequest: state.pendingRequests[index]),
                      ),
                      itemCount: state.pendingRequests.length,
                    ),
                  ),
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
