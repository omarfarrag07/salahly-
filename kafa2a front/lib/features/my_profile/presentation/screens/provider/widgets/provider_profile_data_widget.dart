import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProviderProfileDataWidget extends StatelessWidget {
  const ProviderProfileDataWidget(
      {super.key, required this.label, required this.data});
  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text(
          "$label: $data",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
