import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/features/home/provider/data/models/get_all_requests_response/all_provider_requests.dart';
import 'package:kafa2a/features/home/provider/presentation/cubit/provider_offers_cubit.dart';
import 'package:kafa2a/features/home/provider/presentation/screens/widgets/send_offer_bottom_sheet.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';
import 'package:intl/intl.dart';

class ProviderOfferItemWidget extends StatefulWidget {
  const ProviderOfferItemWidget(
      {super.key, required this.request, this.customFooter});
  final AllProviderRequests request;
  final Widget? customFooter;

  @override
  State<ProviderOfferItemWidget> createState() =>
      _ProviderOfferItemWidgetState();
}

class _ProviderOfferItemWidgetState extends State<ProviderOfferItemWidget> {
  String? _resolvedAddress;

  bool _isLoadingAddress = true;

  @override
  void initState() {
    super.initState();
    _resolveLocationName(); // fetch the address on load
  }

  void _resolveLocationName() async {
    final lat = widget.request.lat;
    final lng = widget.request.lng;

    if (lat != null && lng != null) {
      try {
        final place = (await placemarkFromCoordinates(
                double.parse(lat), double.parse(lng)))
            .first;
        final city = place.locality ?? place.administrativeArea ?? '';
        final country = place.country ?? '';
        setState(() {
          _resolvedAddress = '$city, $country';
          _isLoadingAddress = false;
        });
      } catch (_) {
        setState(() {
          _resolvedAddress = '$lat, $lng';
          _isLoadingAddress = false;
        });
      }
    } else {
      setState(() {
        _resolvedAddress = null;
        _isLoadingAddress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final serviceName = locale == 'ar'
        ? (widget.request.service?.nameAr ?? '')
        : (widget.request.service?.nameEn ?? '');
    final description = widget.request.description;
    String formattedTime = formatDateTime(context, widget.request.scheduledAt);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                Icon(Icons.person, color: ColorsManager.blue, size: 20.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '${widget.request.user.name} - ${widget.request.title}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Divider(color: Colors.grey.shade200, thickness: 1),

            /// Info rows
            _buildInfoRow(context, Icons.price_change_outlined,
                AppLocalizations.of(context).price, widget.request.price,
                isBoldValue: true),
            _buildInfoRow(context, Icons.description_outlined,
                AppLocalizations.of(context).description, description),
            _buildInfoRow(context, Icons.home_repair_service_outlined,
                AppLocalizations.of(context).service, serviceName),
            _buildInfoRow(context, Icons.access_time_outlined,
                AppLocalizations.of(context).time, formattedTime),
            _buildInfoRow(context, Icons.location_on_outlined,
                AppLocalizations.of(context).location, _resolvedAddress ?? ''),
            _buildInfoRow(
              context,
              Icons.info_outline,
              AppLocalizations.of(context).status,
              getLocalizedStatus(context, widget.request.status),
              valueColor: ColorsManager.blue,
              isBoldValue: true,
            ),

            /// Offer Button
            if (widget.customFooter != null) ...[
              SizedBox(height: 12.h),
              widget.customFooter!,
            ] else if (!widget.request.hasOffered) ...[
              SizedBox(height: 12.h),
              _StyledOfferButton(request: widget.request),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String title,
    String value, {
    bool isBoldValue = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ColorsManager.blue, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$title: ',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontWeight:
                          isBoldValue ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16.sp,
                      color: valueColor ?? Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getLocalizedStatus(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppLocalizations.of(context).pending;
      case 'accepted':
        return AppLocalizations.of(context).accepted;
      case 'rejected':
        return AppLocalizations.of(context).rejected;
      case 'paid':
        return AppLocalizations.of(context).paid;
      case 'cancelled':
        return AppLocalizations.of(context).cancelled;
      case 'completed':
        return AppLocalizations.of(context).completed;
      default:
        return status;
    }
  }
}

class _StyledOfferButton extends StatefulWidget {
  final AllProviderRequests request;
  const _StyledOfferButton({Key? key, required this.request}) : super(key: key);

  @override
  State<_StyledOfferButton> createState() => _StyledOfferButtonState();
}

class _StyledOfferButtonState extends State<_StyledOfferButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final isWebOrDesktop = Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux;

    return MouseRegion(
      onEnter: (_) {
        if (isWebOrDesktop) setState(() => _hovering = true);
      },
      onExit: (_) {
        if (isWebOrDesktop) setState(() => _hovering = false);
      },
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<ProviderOffersCubit>(),
              child: SendOfferBottomSheet(request: widget.request),
            ),
          );
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: _hovering ? Colors.white : ColorsManager.blue,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorsManager.blue, width: 2),
            boxShadow: [
              BoxShadow(
                color: ColorsManager.blue.withOpacity(0.08),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(context).offer,
              style: TextStyle(
                color: _hovering ? ColorsManager.blue : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String formatDateTime(BuildContext context, String dateTimeString) {
  try {
    final locale = Localizations.localeOf(context).languageCode;
    final dateTime = DateTime.parse(dateTimeString);
    if (locale == 'ar') {
      // Example: الأحد الساعة 6 ص
      return DateFormat('EEEE الساعة h a', 'ar').format(dateTime);
    } else {
      // Example: Sunday 6 AM
      return DateFormat('EEEE h a', 'en').format(dateTime);
    }
  } catch (e) {
    return dateTimeString;
  }
}
