import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_requests/all_requests.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptedRequestItemWidget extends StatelessWidget {
  const AcceptedRequestItemWidget({super.key, required this.acceptedRequest});
  final AllRequests acceptedRequest;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: ColorsManager.blue,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                      acceptedRequest.price,
                      style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.bold),
                    )),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: ColorsManager.blue,
                        ),
                        Text(
                          "${AppLocalizations.of(context).serviceProvider}: ${acceptedRequest.user.name}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: ColorsManager.blue,
                        ),
                        Text(
                          "Service",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "Plumber",
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Icon(Icons.description, color: ColorsManager.blue),
                        Text(
                          AppLocalizations.of(context).description,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      acceptedRequest.description,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Colors.red,
                        ),
                        Text(
                          AppLocalizations.of(context).location,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      acceptedRequest.lat,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            color: ColorsManager.blue),
                        Text(
                          AppLocalizations.of(context).time,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      acceptedRequest.scheduledAt,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final Uri phoneUri =
                      Uri(scheme: 'tel', path: acceptedRequest.user.phone);
                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri,
                        mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch phone dialer')),
                    );
                  }
                },
                child: Row(
                  children: [
                    Spacer(),
                    Text(
                      acceptedRequest.user.phone,
                    ),
                    Spacer(),
                    Icon(Icons.phone)
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
