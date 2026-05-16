import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/core/utils/validators.dart';
import 'package:kafa2a/core/widgets/default_submit_button.dart';
import 'package:kafa2a/core/widgets/offer_text_form_field.dart';
import 'package:kafa2a/core/widgets/ui_utils.dart';
import 'package:kafa2a/features/home/provider/data/models/get_all_requests_response/all_provider_requests.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_request.dart';
import 'package:kafa2a/features/home/provider/presentation/cubit/provider_offers_cubit.dart';
import 'package:kafa2a/features/home/provider/presentation/cubit/provider_offers_states.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';
import 'package:intl/intl.dart';

class SendOfferBottomSheet extends StatefulWidget {
  const SendOfferBottomSheet({super.key, required this.request});
  final AllProviderRequests request;

  @override
  State<SendOfferBottomSheet> createState() => _SendOfferBottomSheetState();
}

class _SendOfferBottomSheetState extends State<SendOfferBottomSheet> {
  TextEditingController priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 20.h,
          left: 20.w,
          right: 20.w,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        width: double.infinity,
        height: 350.h,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formatDateTime(context, widget.request.scheduledAt),
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  AppLocalizations.of(context).customerWantsToPay,
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 6.h),
                Text(widget.request.price,
                    style: TextStyle(
                        fontSize: 30.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.h),
                Text(
                  AppLocalizations.of(context).whatIsYourOffer,
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10.h),
                Form(
                  key: formKey,
                  child: SizedBox(
                    height: 80.h,
                    child: OfferTextFormField(
                      controller: priceController,
                      validator: (offer) => Validators.validateNull(
                          offer, AppLocalizations.of(context).priceRequired),
                      hintText: AppLocalizations.of(context).enterYourOffer,
                      textStyle: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocConsumer<ProviderOffersCubit, ProviderOffersStates>(
                      listener: (_, state) {
                        if (state is SendOfferLoadingState) {
                          UIUtils.showLoading(context);
                        } else if (state is SendOfferErrorState) {
                          UIUtils.hideLoading(context);
                          Navigator.pop(context);
                          UIUtils.showMessage(state.error);
                          context.read<ProviderOffersCubit>().getAllRequests();
                        } else if (state is SendOfferSuccessState) {
                          UIUtils.showMessage(state.message);
                          Navigator.pop(context);
                          context.read<ProviderOffersCubit>().getAllRequests();
                        }
                      },
                      builder: (context, state) => SizedBox(
                        width: 150.w,
                        height: 45.h,
                        child: DefaultSubmitButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<ProviderOffersCubit>().sendOffer(
                                      SendOfferRequest(
                                        price: int.parse(priceController.text),
                                        offerId: widget.request.id,
                                      ),
                                    );
                              }
                            },
                            label: AppLocalizations.of(context).sendOffer),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(150.w, 45.h)),
                        child: Text(AppLocalizations.of(context).close))
                  ],
                ),
              ],
            ),
          ],
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
      return DateFormat('EEEE الساعة h a', 'ar').format(dateTime);
    } else {
      return DateFormat('EEEE h a', 'en').format(dateTime);
    }
  } catch (e) {
    return dateTimeString;
  }
}
