import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kafa2a/config/app_styles.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/features/home/user/domain/entities/services.dart';

class ServicesDropDownWidget extends StatefulWidget {
  const ServicesDropDownWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.services,
    required this.onChanged,
  });

  final Function(Services)? onChanged;
  final String hint;
  final String label;
  final List<Services>? services;

  @override
  State<ServicesDropDownWidget> createState() => _ServicesDropDownWidgetState();
}

class _ServicesDropDownWidgetState extends State<ServicesDropDownWidget> {
  Services? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppStyles.body,
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: ColorsManager.blue,
              ),
              borderRadius: BorderRadius.circular(12.r)),
          width: double.infinity,
          child: DropdownButton(
            underline: Container(),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            icon: Icon(
              Icons.arrow_drop_down,
              color: ColorsManager.blue,
            ),
            borderRadius: BorderRadius.circular(12.r),
            style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 16.sp,
                textStyle: TextStyle(overflow: TextOverflow.ellipsis)),
            value: null,
            isExpanded: true,
            items: widget.services?.map((Services service) {
              return DropdownMenuItem<Services>(
                value: service,
                child: Text(service.name),
              );
            }).toList(),
            onChanged: (value) {
              selectedItem = value;
              if (widget.onChanged != null) {
                widget.onChanged!(value!);
              }
              setState(() {});
            },
            hint: Text(selectedItem?.name ?? widget.hint,
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16.sp,
                    textStyle: TextStyle(overflow: TextOverflow.ellipsis))),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
