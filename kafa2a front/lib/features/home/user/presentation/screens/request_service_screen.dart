import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kafa2a/config/app_styles.dart';
import 'package:kafa2a/core/screens/pick_location_screen.dart';
import 'package:kafa2a/core/utils/validators.dart';
import 'package:kafa2a/core/widgets/default_elevated_button.dart';
import 'package:kafa2a/core/widgets/default_submit_button.dart';
import 'package:kafa2a/core/widgets/default_text_form_field.dart';
import 'package:kafa2a/core/widgets/loading_indicator.dart';
import 'package:kafa2a/core/widgets/ui_utils.dart';
import 'package:kafa2a/core/widgets/offer_text_form_field.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_states.dart';
import 'package:kafa2a/features/home/user/data/models/request_service_request.dart';
import 'package:kafa2a/features/home/user/domain/entities/category.dart';
import 'package:kafa2a/features/home/user/presentation/cubit/request_service/request_service_cubit.dart';
import 'package:kafa2a/features/home/user/presentation/cubit/request_service/request_service_states.dart';
import 'package:kafa2a/features/home/user/presentation/screens/widgets/categories_drop_down_widget.dart';
import 'package:kafa2a/features/home/user/presentation/screens/widgets/services_drop_down_widget.dart';
import 'package:kafa2a/features/my_profile/presentation/cubit/profile_cubit.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class RequestServiceScreen extends StatefulWidget {
  const RequestServiceScreen({super.key});

  @override
  State<RequestServiceScreen> createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends State<RequestServiceScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController priceController = TextEditingController();
  Category? selectedCategory;
  String? selectedDate;
  int? selectedService;
  DateTime? selectedTimePicker;
  final TextEditingController titleController = TextEditingController();
  LatLng? selectedLatLng;

  @override
  void dispose() {
    descriptionController.dispose();
    priceController.dispose();
    titleController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    String dateTime =
        DateFormat('dd-MM-yyyy', context.read<ProfileCubit>().getLanguage())
            .format(date);
    String time =
        DateFormat('hh:mm a', context.read<ProfileCubit>().getLanguage())
            .format(date);
    return "$dateTime  $time";
  }

  Future<DateTime?> pickDateTime() async {
    return await DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        selectedDate = formatDate(date);
        selectedTimePicker = date;
        setState(() {});
      },
      minTime: DateTime.now(),
      currentTime: selectedTimePicker ?? DateTime.now(),
      locale: context.read<ProfileCubit>().getLanguage() == 'ar'
          ? LocaleType.ar
          : LocaleType.en,
    );
  }

  @override
  void initState() {
    context.read<RequestServiceCubit>().getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).requestService),
        centerTitle: true,
      ),
      body: BlocConsumer<RequestServiceCubit, RequestServiceStates>(
        builder: (context, state) {
          if (state is GetCategoriesSuccessState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoriesDropDownWidget(
                        label: AppLocalizations.of(context).category,
                        hint: AppLocalizations.of(context).selectCategory,
                        categories: state.categories,
                        onChanged: (value) {
                          selectedCategory = value;
                          setState(() {});
                        },
                      ),
                      ServicesDropDownWidget(
                        label: AppLocalizations.of(context).services,
                        hint: AppLocalizations.of(context).selectService,
                        services: selectedCategory?.services,
                        onChanged: (value) {
                          selectedService = value.id;
                        },
                      ),
                      Text(
                        AppLocalizations.of(context).title,
                        style: AppStyles.body,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      DefaultTextFormField(
                        controller: titleController,
                        hintText: AppLocalizations.of(context).pleaseEnterTitle,
                        validator: (address) => Validators.validateNull(address,
                            AppLocalizations.of(context).titleRequired),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        AppLocalizations.of(context).description,
                        style: AppStyles.body,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      BlocBuilder<AuthCubit, AuthStates>(
                        buildWhen: (previous, current) =>
                            current is LocationNameSuccessState,
                        builder: (context, state) {
                          String locationName =
                              AppLocalizations.of(context).pickYourLocation;
                          if (state is LocationNameSuccessState) {
                            locationName = state.locationName;
                          }
                          return DefaultElevatedButton(
                            onPressed: () async {
                              await context.read<AuthCubit>().getLocation();
                              if (context.mounted) {
                                final pickedLatLng =
                                    await Navigator.push<LatLng>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PickLocationScreen(),
                                  ),
                                );
                                if (pickedLatLng != null && context.mounted) {
                                  selectedLatLng = pickedLatLng;
                                }
                              }
                            },
                            label: locationName,
                          );
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        AppLocalizations.of(context).preferedTime,
                        style: AppStyles.body,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: DefaultElevatedButton(
                          onPressed: () {
                            pickDateTime();
                          },
                          label: selectedDate ??
                              AppLocalizations.of(context).selectDateAndTime,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        AppLocalizations.of(context).price,
                        style: AppStyles.body,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      OfferTextFormField(
                        hintText:
                            AppLocalizations.of(context).pleaseEnterYourPrice,
                        controller: priceController,
                        validator: (price) => Validators.validateNull(
                            price, AppLocalizations.of(context).priceRequired),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      DefaultSubmitButton(
                          label: AppLocalizations.of(context).requestService,
                          onPressed: () {
                            if (formKey.currentState!.validate() &&
                                selectedCategory != null &&
                                selectedService != null &&
                                selectedDate != null) {
                              context
                                  .read<RequestServiceCubit>()
                                  .requestService(
                                    RequestServiceRequest(
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      lat: selectedLatLng!.latitude.toString(),
                                      lng: selectedLatLng!.longitude.toString(),
                                      price: int.parse(priceController.text),
                                      scheduledAt: selectedDate!,
                                      serviceId: selectedService!,
                                    ),
                                  );
                            }
                          }),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is GetCategoriesErrorState) {
            return Center(child: Text(state.error));
          } else if (state is GetCategoriesLoadingState) {
            return LoadingIndicator();
          } else {
            return SizedBox();
          }
        },
        listener: (context, state) async {
          if (state is RequestServiceLoadingState) {
            UIUtils.showLoading(context);
          } else if (state is RequestServiceErrorState) {
            UIUtils.hideLoading(context);
            UIUtils.showMessage(state.error);
          } else if (state is RequestServiceSuccessState) {
            UIUtils.hideLoading(context);
            UIUtils.showMessage(
                AppLocalizations.of(context).serviceRequestedSuccessfully);
            if (context.mounted) {
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }
}
